# Contract Reconciliation — FE ↔ BE (หลัง review รอบแรก 2026-07-20)

> ⚠️ **SUPERSEDED (21 ก.ค. 2026 — tech stack pivot):** เอกสารนี้บันทึกการ reconcile ความต่างระหว่างโค้ด FE/BE ของ **stack เดิม** (`syndome-crm-mvc-ui` .NET MVC + `syndome-crm-api` .NET Web API/EF Core) ที่เขียนแยกกันแล้วเกิด drift — ตอนนี้ระบบเป็น standalone ใหม่ทั้งชุด (React + Node.js/Fastify + PostgreSQL, ดู impact assessment `0c`) **ยังไม่มีโค้ด FE/BE ของ stack ใหม่เขียนขึ้นเลย** จึงไม่มี "drift" ให้ reconcile ในความหมายเดิม — เอกสารนี้เก็บไว้เป็น **ประวัติการตัดสินใจ ไม่ใช่ contract ที่ยัง apply กับ stack ใหม่** (ชื่อ C# class, path ไฟล์ `.cs`, พฤติกรรม Newtonsoft/EF/`dotnet build` ด้านล่างทั้งหมดอ้างอิงเฉพาะ stack เดิมที่เลิกใช้แล้ว) เนื้อหาด้านล่างนี้**ไม่ถูกแก้ไข** ตามหลักการเดียวกับที่ impact assessment เก็บหัวข้อ 9 ไว้เป็นประวัติ — ถ้าต้องการ field-shape decision ที่ยังใช้อ้างอิงได้ (เช่น "เพิ่ม `NewEntryStatusName` คู่กับ code เพื่อโชว์ toast", "list ใช้ DataTables-lite paging", "วันที่เป็น ISO string") ให้ตีความเป็นแนวคิดกว้างๆ ไปปรับใช้กับ Fastify API contract จริงตอน implement ไม่ใช่คัดลอกชื่อ field/class ตรงๆ

เอกสารนี้คือ **คำตัดสิน canonical contract** ต่อ endpoint หลังตรวจพบ drift ระหว่างโค้ดที่ FE (`syndome-crm-mvc-ui`) และ BE (`syndome-crm-api`) implement แยกกัน ใครถูกระบุว่า "แก้" ให้แก้ตามนี้เท่านั้น ห้ามเปลี่ยน shape ฝั่งตรงข้าม

หลักการตัดสิน:
- **List endpoints ใช้ DataTables-lite ตาม FE** — Appendix B ข้อ 1 ระบุ "paging (DataTable style)" และ convention เดิมของ API (`CustomerListRequest`, `ToDoListListRequest`) ก็เป็น DataTables อยู่แล้ว
- **Body/response อื่นใช้ BE flat shape** — API เป็นเจ้าของ contract, MVC controller เป็น adapter
- **ชื่อ field ที่ JS อ่าน ยึดตาม FE DTO** ในจุดที่ระบุ เพราะ JS เป็น string-typed (compiler จับไม่ได้) ส่วน BE mapping มี compiler ตรวจ

การ bind ทั้งสองทาง case-insensitive อยู่แล้ว (Newtonsoft / STJ web defaults) — ที่ต้องตรงคือ **ชื่อ property** ไม่ใช่ casing

---

## A. BE ต้องแก้ (`syndome-crm-api`)

### A1. List endpoints ทั้ง 5 ตัว → เปลี่ยนเป็น DataTables-lite ตาม FE
endpoints: `/list`, `/to-do-list`, `/status-update-list`, `/approve-list`, `/leader/list`

Request — เปลี่ยนจาก `Page/PageSize/SearchText/...` เป็น **shape ของ FE ทั้งชุด** (อ่านไฟล์ FE เป็น source):
- `/list` → `syndome-crm-mvc-ui/Models/Request/ProjectRegisterListRequest.cs` (`Draw`, `Start`, `Length`, `SearchValue`, `SortField` team|sales|due, `SortDirection`, `TeamID`, `SaleUserName`, `DueDateFrom`, `DueDateTo`, `StatusID` — **filter ด้วย StatusID (long) ไม่ใช่ statusCode**)
- `/to-do-list` → `ProjectRegisterToDoListRequest.cs` (`Draw/Start/Length/SearchValue` + `FilterCard`)
- `/status-update-list` → `ProjectRegisterStatusUpdateListRequest.cs` (FE ใช้ชื่อ class นี้)
- `/approve-list` → `ProjectApproveListRequest.cs` (`Draw/Start/Length/SearchValue` + `FilterType` + `Scope` = head|supervisor — ใช้ Scope เลือก tier แทนการเดาจาก role เมื่อเป็น admin/ผู้ที่มีหลาย role; ยังต้องบังคับสิทธิ์จาก JWT เหมือนเดิม)
- `/leader/list` → `ProjectLeaderListRequest.cs` (`Draw/Start/Length/SearchValue` + `FilterStatus`)

Response — ทุก list ตอบ: `Draw` (echo), `RecordsTotal`, `RecordsFiltered`, `Data` และ summary ตามชื่อ FE:
- to-do-list: property `Counts` class ตาม FE `CardCounts` {All, Waiting, Rejected, NearDue, Approved} (เดิม BE ใช้ `Summary.WaitingApproval` → เปลี่ยนเป็น `Counts.Waiting`)
- approve-list: property `Counts` ตาม FE `CountSummary` {All, Register, Won, Lost, PostponeEdit} (เดิม RegisterAndPm/PostponeOrEdit)
- leader/list: `PendingCount` (เดิม UnassignedCount) + row shape ตาม FE `ProjectLeaderListResponse` (อ่านไฟล์ FE)

### A2. Row DTO `ProjectEntryDto` → เปลี่ยนชื่อ property ให้ตรง FE `ProjectEntryRowDto`
(ไฟล์ FE: `Models/Response/ProjectRegisterShared.cs`) — จุดต่างที่พบ:
- `ID` → **`EntryID`**
- `CanUpdate` → **`CanUpdateStatus`**
- เพิ่ม **`DealerName`** (ชื่อ dealer สำหรับแสดงผล — ดึงจากส่วน name ของ snapshot หรือ join TMDealer)
- เพิ่ม **`SaleName`** (ชื่อแสดงผลของ sales จาก TMUser ถ้ามี ไม่มีให้ = SaleUserName)
- เพิ่ม **`IsRejected`** (bool ต่อแถว — EntryStatus `rejected` หรือมี request ที่ `RequestStatus='rejected'` ตาม R1 ซึ่ง logic นี้มีอยู่แล้วใน GetToDoList แบบ anonymous → ย้ายเข้า DTO)
- field อื่นที่ BE มีเกิน FE ปล่อยไว้ได้ (FE ignore)

### A3. `/approve-list` rows → เปลี่ยนจาก ProjectEntryDto เป็น request-oriented ตาม FE
FE `ProjectApproveListResponse.ResponseData`: {EntryID, RequestID, ProjectCode, EntryCode, ApprovalType (register|won|lost|postpone|editRequest|editRevision), RequestTypeName, SaleUserName, SaleName, TeamName, SubmitDate, StatusID, StatusName} — approve zone เป็นรายการ "คำขอ" ไม่ใช่รายการ Entry

### A4. Notification → ตาม FE shape
FE `ProjectNotificationResponse`: `UnreadCount` (เดิม UnreadEventCount), `Events[]` มี `EntryCode`, `NearDue[]` มี `OrgName`, `EntryCode`, `DaysRemaining`, `ExpectFinishDate` — เพิ่ม field ที่ขาดใน `ProjectNotificationItemDto` (มีเกินได้)

### A5. เพิ่ม endpoint `config/dealer/list` + `config/dealer/save` (admin)
FE มีจอ ConfigDealer แล้ว (proposal ระบุ Dealer เป็น master admin-managed) — shape ตาม FE `Models/Request/ProjectConfigDealerRequest.cs` / `Models/Response/ProjectConfigDealerResponse.cs` (อ่านไฟล์ FE): list ทั้งหมดรวม inactive + save upsert (ID=0 insert) + toggle IsActive; สิทธิ์ admin เหมือน config อื่น

### A6. Action responses → เพิ่ม `NewEntryStatusName`
`ProjectStatusRequestSaveResponse`, `ProjectApprovalActionResponse`, `ProjectEntryRevisionSubmitResponse` — เพิ่ม `NewEntryStatusName` คู่กับ `NewEntryStatusCode` (FE ใช้แสดง toast/badge)

### A7. `/compare` → เปลี่ยน response เป็น shape ของ FE ทั้งก้อน
FE `ProjectCompareResponse`: `Project` {ProjectID, ProjectCode, OrgName, ProjectName, ProjectStatus, LeaderEntryID} + `Entries[]` EntryCompareDto {EntryID, EntryCode, EntrySequence, SaleUserName, SaleName, TeamName, DealerName, SaleCondition, ExpectFinishDate, StatusID, StatusName, BadgeStyle, IsLeader, PmEligible, TotalCost, TotalSell, TotalGp, GpPct, IsLowestCost, IsHighestSell, IsBestGp, Tasks[], RejectReasons[]}
- `RejectReasons` = ProjectApprovalDto ของ entry นั้นที่ Action='reject' (BE เพิ่ม `ActionByName` ใน ProjectApprovalDto — ใส่ชื่อแสดงผลจาก TMUser ถ้าได้ ไม่ได้ให้ = ActionBy)
- ตัด `PmCompare` แยกก้อนทิ้ง (ย้ายตัวเลขรวมเข้า EntryCompareDto ต่อ entry)

### A8. `/entry-revisions` → response ตาม FE
`Revisions[]` (summary: ID, RevisionNo, RevisionStatus, IsCurrentRevision, CreateDate, UpdateDate) + `SelectedRevisionDetail` (detail ของ revision เมื่อ request ส่ง `RevisionID` มา) — FE request มี `RevisionID` optional

### A9. `ProjectApprovalDto` → เพิ่ม `ActionByName` (ใช้ทั้ง detail + compare)

---

## B. FE ต้องแก้ (`syndome-crm-mvc-ui`)

### B1. `/save` + `/entry-revision/submit` → flatten เป็น BE shape ก่อน forward
BE เป็น canonical (อ่าน `syndome-crm-api/Models/Request/ProjectRegister/ProjectRegisterSaveRequest.cs` + `ProjectEntryRevisionSubmitRequest.cs`): flat fields — ไม่มี nested `Project`/`Entry`
ทำ mapping ใน MVC controller (JS + form ไม่ต้องแก้):
- `JoinExistingProject=true` + `ProjectID` → `ExistingProjectID`
- nested `Project.*`/`Entry.*` → flat (`OrgName`, `ProjectName`, `OrgTypeID`, `TeamID`, `DealerID`, `SaleCondition`, `ExpectFinishDate`, `Warranty*`)
- **ตัด `Entry.SaleUserName` / `DealerSnapshot` ทิ้ง** (BE ผูก owner จาก JWT + สร้าง snapshot เอง — D28)
- Products: ข้ามแถว `IsDelete=true`, ไม่ส่ง `ID`/`Amount` (BE replace ทั้งชุดต่อ revision + คำนวณเอง)
- Tasks: ข้าม `IsDelete=true`; map `ClientKey`/`ClientParentKey` (string) → `TempID`/`ParentTempID` (long) ด้วยเลข running 1..n ใน request เดียว; ไม่ส่ง `ID`
- `RevisionID` ไม่ต้องส่งใน `/save` (BE ใช้ EntryID>0 = แก้ draft/rejected เดิม) แต่ `/entry-revision/submit` ต้องส่ง `EntryID`+`RevisionID`
- BE ไม่มี `IsDraft` ใน revision/submit (submit คือ submit — ไม่มีร่างของร่าง) → FE ปุ่ม "บันทึกร่าง" ของ S8 ให้เซฟ local/ไม่เรียก API หรือซ่อนไป

### B2. Response DTO → ยึด BE flat shape แล้วไล่แก้ JS accessor
- `/save`: BE ตอบ flat {ProjectID, ProjectCode, EntryID, EntryCode, RevisionID, EntryStatusCode} — ไม่มี `Data` wrapper
- `/detail`: BE ตอบ flat {Entry, Files, Products, Tasks, StatusRequests, StatusLogs, Approvals, CanEdit, CanUpdateStatus} — ไม่มี wrapper; `Entry` ใช้ชื่อ field ตาม `ProjectEntryRowDto` (BE กำลัง rename ตาม A2)
- `/file/save`: BE ตอบ {FileID}
- `/status-request/save`, `/approve`, `/reject`, `/entry-revision/submit`: {EntryID, NewEntryStatusCode, NewEntryStatusName, (ProjectStatus)} — เลิกใช้ StatusID/StatusName เดิมของ FE
- `/config/*` responses + master lookups 6 ตัว (`api/master/v1/project-status`, `project-team`, `project-org-type`, `competitor-brand`, `project-lost-reason`, `project-collapse-reason`): ตรวจชื่อ field เทียบไฟล์ BE (`Controllers/ProjectMasterController.cs`, `Models/Response/ProjectRegister/*`) แล้วแก้ FE DTO/JS ให้ตรง — ถ้า field ที่จอจำเป็นต้องใช้ไม่มีใน BE ให้รายงาน อย่าเงียบ

### B3. แก้ field ชี้เป้าใน request เล็ก ๆ
- `/leader/assign`: `LeaderEntryID` → **`EntryID`** (DTO + JS payload)
- `/dealer/search`: `Keyword` → **`SearchText`**
- `/dealer/add`: เพิ่ม `ProvinceName`, `AmphurName`, `TambonName` (BE เก็บ snapshot ชื่อ — FE มีค่าจาก dropdown อยู่แล้ว)

### B4. FE `ProjectTaskDto` (Response) — เปลี่ยน `BidCompetitorUnit/BidCompetitorAmt` เป็น `decimal?`
BE ส่ง null ได้ → Newtonsoft deserialize null → non-nullable decimal จะ throw — **ตัด `BidSocomecUnit`/`BidSocomecAmt` ออกจาก DTO ทั้งคู่ (คอลัมน์ถูกตัดออกจาก scope) — ถ้า BE ยังส่ง field นี้มาอยู่ ให้ BE ลบออกจาก response ด้วย ไม่ใช่แค่ฝั่ง FE เพิกเฉย**

### B5. FE `ProjectStatusRequestDto` (Response) — เพิ่ม `RejectReason`, `ActionBy`, `ActionDate`, `LostReasonID`, `CollapseReasonID`
จอ reject-history (S3a) ต้องใช้; BE มีให้แล้ว

### B6. FE `ProjectTeamDto` — เพิ่ม `Users` list ตาม BE (`ProjectTeamUserDto` {ID, UserName, RoleInTeam})
จอ ConfigTeam ต้องใช้ matrix

### B7. วันที่: BE ตอบ DateTime เป็น ISO string ("2026-07-20T00:00:00") — ตรวจว่า JS format ก่อนแสดงทุกจุด

---

## C. เข้ากันได้อยู่แล้ว — ห้ามแก้
- `/approve`, `/reject` request (BE ignore `RequestID`/`ApprovalType` ที่ FE ส่งเกิน; `Reason` มีแล้ว)
- `/duplicate-check` request/response
- `/file/save`, `/file/delete` request (`ProjectFileRequest`)
- config master (competitor-brand/org-type/lost-reason/collapse-reason) + config notification + config team **request** shapes
- `/status-request/save` request (FE ส่ง `OldExpectDate` เกิน — BE คำนวณเองและ ignore)

## D. ข้อห้ามเดิม
ห้าม commit / push / สลับ branch ทั้งสอง repo — งานอยู่บน `feat/project-register` แบบ uncommitted รอ review
เสร็จแล้วต้อง `dotnet build` ผ่าน 0 error (ไม่มี warning ใหม่)
