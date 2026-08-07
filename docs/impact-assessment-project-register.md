# Impact Assessment — ฟีเจอร์ Project Register / Project Management

| หัวข้อ | รายละเอียด |
|---|---|
| วันที่ประเมิน | 17 ก.ค. 2026 — ปรับตาม updated-flow 18 ก.ค. 2026 — รอบ review + ปิดคำถาม 9.22–9.24 วันที่ 19 ก.ค. 2026 — 21 ก.ค. 2026: รอบ Re-platform เปลี่ยน tech stack ทั้งหมด (ดูหัวข้อ 0c) — 21 ก.ค. 2026 (รอบ 6): ปิดคำถาม SSO ตามเอกสาร integration guide ที่ผู้ใช้ให้มา (ดูหัวข้อ 9c) — 22 ก.ค. 2026 (รอบ 7): เพิ่มขอบเขต Mobile Responsive + แจ้งเตือนอนุมัติผ่าน LINE Flex Message (ดูหัวข้อ 0d) — 22 ก.ค. 2026 (รอบ 8): เพิ่มขอบเขต AI Chat Assistant สำหรับค้นหา/สรุปข้อมูลโครงการผ่านแชท (ดูหัวข้อ 0e) — **23 ก.ค. 2026 (รอบ 9): ทำ mockup ต้นแบบหน้าจอมือถือ (AI Chat Assistant + LINE Push) ขึ้นเองเพื่อสาธิต UX ของ 0d/0e — ไม่ใช่ requirement/ขอบเขตใหม่ ไม่กระทบประมาณการงาน (ดูหัวข้อ 4.6)** — **30 ก.ค. 2026 (รอบ 11): ตัดขอบเขต AI Chat Assistant ออกทั้งก้อน เหลือช่องทาง push ผ่าน LINE + Telegram เท่านั้น (ดูหัวข้อ 0g)** — **27 ก.ค. 2026 (รอบ 10): ผู้ใช้ส่ง Template Excel ของตาราง Project Management ที่ใช้งานจริง + ตอบคำถามค้างจากรอบ review → เขียนภาคผนวก A.8 ใหม่ทั้งหัวข้อ และปิดคำถาม 8 ข้อ (ดูหัวข้อ 0f)** |
| แหล่งข้อมูล Prototype | เดิม: `C:\Users\SYN\Downloads\UI_ProjectRegister\Role_Sale.html`, `Role_HeadSale.html`<br>**ยึดชุดนี้:** `prototype/Role_Sale_Lastest.html`, `prototype/Role_HeadSale_Lastest.html`, `prototype/Role_Manager_Lastest.html`, `prototype/FlowProjectRegis(Update)_compressed.pdf` — **🆕 27 ก.ค. 2026: `prototype/Template_ProjectManagement.xlsx` (sheet `หลายรายการ`) ไฟล์ที่ทีมขายใช้กรอกงานจริง = source of truth ของ "ตาราง Project Management" แทนตาราง PM ใน prototype HTML (ดู 0f, A.8)** — Prototype เป็น HTML/CSS/JS ธรรมดา ใช้เป็นแหล่งอ้างอิง UX/field/workflow ต่อได้ตามเดิม ไม่ผูกกับ backend เดิมแต่อย่างใด **หมายเหตุ: Prototype ไม่เคยครอบคลุม mobile/LINE/AI Chat — ส่วนนี้ไม่มีของเดิมให้อ้างอิง (ดู 0d/0e)** — **0e (AI Chat Assistant) ผู้ใช้ระบุ requirement ละเอียดในแชทแล้ว (FR-01–FR-11 พร้อมตัวอย่างคำถาม/คำตอบจริง — พิมพ์ในแชทโดยตรง ไม่ใช่เอกสารแนบ) — ละเอียดกว่าคำขอสั้นๆ ของรอบ 0d** — **23 ก.ค. 2026: มี mockup หน้าจอ chat + LINE push แล้ว (`prototype/ChatAssistant_Mobile_Prototype.html`) แต่เป็นไฟล์ที่ทำขึ้นเองระหว่างงานนี้เพื่อสาธิต ไม่ใช่ Prototype ที่ผู้ใช้ส่งมาแบบชุด `Role_*.html` ข้างต้น และยังไม่ผ่านการยืนยันจากผู้ใช้ — ดูรายละเอียด 4.6** |
| ระบบที่กระทบ | **ระบบใหม่แบบ standalone ทั้งชุด** — ✅ ตัดสินใจ 21 ก.ค. 2026: **ไม่ใช้/ไม่ผูกกับ** `syndome-crm-mvc-ui`, `syndome-crm-api`, SQL Server 2016 เดิมอีกต่อไป — Web UI: **React (responsive, desktop+mobile)**, API: **Node.js (Fastify)**, Database: **PostgreSQL**, Auth: **SSO Management** (Authentication Gateway ขององค์กร ผ่าน Active Directory/LDAP) ใช้ **OAuth2 Authorization Code Flow** + JWT RS256 — ดูหัวข้อ 0c/9c, แจ้งเตือน: in-app + **push ผ่าน LINE Messaging API (Flex Message) และ Telegram Bot API** — ดูหัวข้อ 0d/0g, ~~AI Chat Assistant~~ **ตัดออกแล้ว 30 ก.ค. 2026 (ดู 0e/0g)** — ไม่มีการเรียก LLM API ภายนอกในระบบนี้ |
| สถานะเอกสาร | Business requirement/workflow (หัวข้อ 1, 2, 1.3–1.5, ภาคผนวก D) **ยังใช้ได้ทั้งหมด ไม่เปลี่ยน** — หัวข้อ 3–9 + ภาคผนวก A–C **เขียนใหม่ให้ตรง stack ใหม่** (21 ก.ค. 2026) — ✅ **ปิด spec ส่วน auth/access-control แล้ว** ตามเอกสาร SSO integration guide (ดู 9c) — 🆕 22 ก.ค. 2026: เพิ่ม scope mobile + LINE (ดู 0d) — เปิดคำถามใหม่ 9b.11–9b.15 ยังไม่ปิด — 🆕 22 ก.ค. 2026: เพิ่ม scope AI Chat Assistant (ดู 0e) — เปิดคำถามใหม่ 9b.16–9b.21 ยังไม่ปิด — 🆕 **23 ก.ค. 2026: เพิ่ม mockup UI (ดู 4.6) — ไม่ปิดคำถามค้างข้อใดเลย (9b.11/9b.14/9b.16/9b.17/9b.18 ยังเปิดอยู่ทั้งหมด) เป็นแค่ภาพประกอบสำหรับให้ผู้ใช้ feedback เร็วขึ้น** — 🆕 **30 ก.ค. 2026 (รอบ 11): ตัด AI Chat Assistant ออกจากขอบเขต (0e ยุบเหลือหมายเหตุ, ถอด 4.5/6.5/A.15/endpoint 26-26b/ความเสี่ยง 8.19-8.24 เดิม/คำถาม 9b.16-9b.21/scenario D32-D35 ออกทั้งหมด) + เพิ่ม Telegram เป็นช่องทาง push ที่ 2 คู่กับ LINE — เปิดคำถามใหม่ 9b.23-9b.25 ยังไม่ปิด** — 🆕 **27 ก.ค. 2026 (รอบ 10): ปิดคำถามจากรอบ review 8 ข้อ (ดู 0f) — ตาราง Project Management ยึด Template Excel เป็นต้นแบบ (A.8 เขียนใหม่), Project identity เหลือ 2 field, เพิ่ม revision ระดับ Project; เปิดคำถามใหม่ 1 ข้อ (9b.22 — ผูก item master จาก ERP) ยังไม่ปิด** |

---

## 0. สรุปสิ่งที่เปลี่ยนจาก updated-flow (18 ก.ค. 2026)

เทียบ Prototype/flow ชุดใหม่ (`updated-flow/`) กับชุดเดิมที่ใช้ประเมินรอบแรก:

| # | การเปลี่ยนแปลง | ผลกระทบหลัก |
|---|---|---|
| 0.1 | **เพิ่ม Role ที่ 3: Manager (พี่บี)** — มี Prototype ของตัวเอง (`Role_Manager_Lastest.html`) ขั้นอนุมัติของพี่บีที่เดิมสรุปเป็น Phase 2 **ถูกดึงเข้ามาอยู่ใน Phase 1 ทั้งหมด** | ยกเลิกการแบ่ง Phase 2 เดิม — สถานะ `waitingSupervisorWon/Lost` → `won`/`lost` ทำงานจริงรอบนี้; ต้องมี role ใหม่ + เมนู + หน้าอนุมัติของ Manager (ข้อ 9.20) |
| 0.2 | **เมนูใหม่ของ Manager: "ระบุ Leader Project"** — Project ที่มีหลาย Entry ให้ Manager เลือก 1 Entry เป็น Leader | ✅ สรุปแล้ว (9.18): Leader = **flag บน Entry ที่ถูกเลือกตัวเดียว** (1 Leader ต่อ Project) — Entry อื่นไม่ต้อง flag ไม่เปลี่ยนสถานะ ยังแสดงใน compare ตามปกติ → ตาราง/endpoint ใหม่ (ดู 6.1, ภาคผนวก B) |
| 0.3 | **"ไม่ได้งาน" แยกเป็น 2 ทาง: แพ้ / ล่ม** — แพ้ = กรอกเหตุผลที่แพ้ + วิเคราะห์ + Bid Result → หัวหน้า → Manager → `lost`; **ล่ม = ปิดโครงการทันที (`closed`) ไม่ผ่านการอนุมัติใดๆ** พร้อมสาเหตุ/วันที่ปิด/รายละเอียด (required) | สถานะ `closed` **ถูกใช้งานจริงแล้ว** — กลับข้อสรุปเดิม 9.12 ("ยังไม่ทำ"); เพิ่มคอลัมน์ใน StatusRequest + ความเสี่ยงใหม่ 8.9 (Sales ปิดโครงการเองได้โดยไม่มีคนตรวจ) |
| 0.4 | ~~เลข 2 ชุดตาม flowchart (SYS No. + Project ID)~~ | ✅ สรุปแล้ว (9.19): **SYS No. เป็นเลขของอีกระบบ — ยังไม่ทำรอบนี้** → คงเลขรันตัวเดียว `ProjectCode PRJ-YYYY-MM-XXXX` ออกตอนบันทึกสร้าง Register ตาม design เดิม (9.11) และกติกา rename ไฟล์แนบ (9.5) ใช้ได้ตามเดิมไม่มีช่องโหว่ |
| 0.5 | ~~Flowchart ให้พี่บีอนุมัติ Register ตั้งต้นด้วย (ขัดกับ HTML)~~ | ✅ สรุปแล้ว (9.17): **เอาตาม HTML** — Register ตั้งต้นอนุมัติชั้นเดียวที่หัวหน้า (`waiting → presented`) ไม่เพิ่มสถานะ `waitingManager`; พี่บีอนุมัติเฉพาะชั้น `waitingSupervisorWon/Lost` |
| 0.6 | **กติกาแจ้งเตือนละเอียดขึ้น (ตามกล่องหมายเหตุใน flowchart):** เกณฑ์ < 90 วันจากวันคาดจบ, ขอบเขตตาม role — Sale เห็นเฉพาะงานตัวเอง / หัวหน้าเห็นงานลูกทีม / **Manager เห็นทุก Project ในระบบ**, ยกเว้นสถานะ ไม่ได้งาน/ยกเลิก (✅ ข้อ 9.21 เพิ่ม `won` ด้วย — สรุปยกเว้น `won`/`lost`/`closed`) | endpoint `/notification` ต้อง filter ตาม role + matrix ทีม; เกณฑ์วันยังทำเป็น config ได้ตามข้อสรุปเดิม 9.6 (default 90) |
| 0.7 | **หน้า ProjectRegister ALL เพิ่ม sort + filter bar** — sort ได้: ทีม / Sales / วันคาดจบ; filter: ทีม, Sales, วันคาดจบ, Status + ปุ่มล้าง filter | endpoint `/list` เพิ่มพารามิเตอร์ sort field/direction + filter team/sales/dueDate (server-side ตามแนวเดิม 4.3) |
| 0.8 | **เงื่อนไขหน้าเปรียบเทียบชัดขึ้น** — compare เฉพาะ Entry สถานะที่ผ่านอนุมัติ Register+PM แล้ว: `presented, waitingPostpone, waitingEdit, waitingWon, waitingLost, waitingSupervisorWon, waitingSupervisorLost, won, lost, closed` | ยืนยัน logic ฝั่ง server ของ endpoint `/compare` (สอดคล้อง D11 เดิม) |
| 0.9 | **เหตุผลไม่อนุมัติแยก 2 การ์ดตาม role** (หัวหน้า Sales / Supervisor-พี่บี) แสดงฝั่ง Sales ทั้งในหน้า Detail และหน้าเปรียบเทียบ — ฝั่ง Manager ใช้งานจริงแล้วรอบนี้ | `TTDProjectApproval.ApproverRole` (head/supervisor) รองรับอยู่แล้ว — UI ต้องแสดงแยกการ์ดตาม role |

---

## 0b. สรุปการปรับจากรอบ review (19 ก.ค. 2026 — ปิด 8 ประเด็น + คำถามใหม่ 9.22–9.24)

| # | ประเด็น review | การปรับ | จุดที่แก้ |
|---|---|---|---|
| R1 | Reject คำขอเปลี่ยนสถานะแล้ว Entry ค้างที่ `rejected` ไม่มีทางกลับที่ถูกต้อง | **แยก EntryStatus ออกจาก RequestStatus** — Reject คำขอ won/lost/postpone/edit → Entry กลับ `presented` (ตัวคำขอเป็น `rejected` พร้อมเหตุผล); EntryStatus `rejected` ใช้เฉพาะ Reject Register ตั้งต้น — **ทับข้อสรุปเดิม 9.1** | 1.4, 8.2, 9.1, A.8, D21, D27 |
| R2 | ไม่ชัดว่า lifecycle เป็นระดับ Project หรือ Entry | ✅ ข้อ 9.22: **เพิ่ม Project-level lifecycle** (`open/won/lost/closed` — ค่า derived จาก Entry) + กติกา aggregate; list/notification ยังยึดข้อมูลราย Entry ตาม Prototype | 1.5, 9.22, A.4, D26 |
| R3 | Workflow "แก้ไขข้อมูล" ขัดกันเอง (apply ทันที vs clone ให้ Sales แก้) | ✅ ข้อ 9.23: อนุมัติคำขอ = เปิด revision ร่างให้ Sales แก้ → **แก้เสร็จต้องส่งอนุมัติซ้ำ** revision จึงเป็น current | 1.4, 8.6, 9.13, 9.23, A.5b, D17 |
| R4 | โครง revision ชนกับ Leader + ไม่มี invariant คุม current revision | **แยกตาราง `TTDProjectEntry` (identity คงที่) / `TTDProjectEntryRevision` (ข้อมูลฟอร์ม)** — Leader ชี้ Entry ID คงที่, ตัด `IsLeader` เหลือ `TTHProject.LeaderEntryID` เป็น source of truth เดียว, unique filtered index คุม current revision ต่อ Entry | 6.1, A.4, A.5, A.5b, A.12 |
| R5 | Acceptance D22 (แจ้งเตือนตอน "ล่ม") ยังไม่มี design รองรับ | ✅ ข้อ 9.24: เพิ่ม **event notification** — ตาราง `TTNotification` + read state + endpoint 14/14d | 8.9, 9.24, A.11, B, D22 |
| R6 | Authorization ระบุเฉพาะ endpoint อนุมัติ ไม่มี record-level rule | เพิ่ม **Access Matrix endpoint × role** (read/write + record-level) + กติกา actor อ่านจาก JWT claim เท่านั้น ห้ามเชื่อ `LoginUserName` จาก body | B.2, D28 |
| R7 | File upload contract ไม่ครบ (`/save` เป็น JSON แต่ helper รองรับแค่ JSON) + ชื่อไฟล์ `{ProjectCode}_{TIMESTAMP}` ชนได้ | กำหนดลำดับ create → upload (multipart ผ่าน MVC action ตาม pattern Expense) → metadata + การล้าง orphan; ชื่อไฟล์เพิ่ม running suffix `{ProjectCode}_{TIMESTAMP}_{Seq}` | 8.5, A.5b, B ข้อ 24, C.1, D19 |
| R8 | ชื่อตาราง/เลขรันเก่าปะปน (`TMProjectStatus` vs `TMStatus`, `PRJ-XXXX`, `LostReasonTypeID`) | ยึดชื่อ canonical ตามภาคผนวก A ชุดเดียว (`TMStatus`, `TTHProject`, `TTDProjectEntry(+Revision)`, `TTDProjectStatusRequest`, `TTDProjectApproval`, `TTLProjectStatusLog`, `LostReasonID`, `PRJ-YYYY-MM-XXXX`) — แก้หัวข้อ 6.1 ให้ตรง | 6.1 |

---

## 0c. Tech Stack Pivot — Full Re-platform, Standalone System (21 ก.ค. 2026)

การตัดสินใจรอบนี้: **เปลี่ยน tech stack ทั้งหมด และแยกเป็นระบบ standalone ไม่ผูกกับ Syndome CRM เดิมอีกต่อไป** — ผลคือหัวข้อ 3–9 และภาคผนวก A–C ของเอกสารนี้ถูกเขียนใหม่ทั้งหมด (เทียบกับก่อนหน้าที่อ้างอิง .NET 8 MVC / .NET 8 Web API / SQL Server 2016 ของระบบเดิม) ส่วน **หัวข้อ 1 (feature summary), 1.3–1.5 (state/status/lifecycle), ภาคผนวก D (test scenario) และหัวข้อ 0/0b ด้านบน (ประวัติการตัดสินใจ) ไม่เปลี่ยน — business logic/workflow ที่ปิดคำถามไปแล้วทั้ง 24 ข้อยังใช้ได้ทั้งหมด** เปลี่ยนเฉพาะ "ทำอย่างไร" (how/implementation) ไม่ใช่ "ทำอะไร" (what/business rule)

| หัวข้อ | เดิม | ใหม่ |
|---|---|---|
| Database | SQL Server 2016 | **PostgreSQL** (แนะนำ 15+ เพื่อใช้ `GENERATED ALWAYS AS IDENTITY`, JSONB, `pg_trgm`) |
| API | ASP.NET Core 8 Web API (EF Core) | **Node.js + Fastify** |
| UI | ASP.NET Core 8 MVC (Razor) | **React** |
| Auth | JWT ออกโดยระบบ Login เดิมของ Syndome CRM (`username`/`rolename` claim) | **SSO Management** (Authentication Gateway กลางขององค์กร หลังบ้านคือ Active Directory/LDAP) — **OAuth2 Authorization Code Flow**, JWT **RS256** ออกโดย SSO (`sub`=sAMAccountName, `roles`=app-specific role array), verify ฝั่งเราด้วย public key แบบ local ไม่ต้อง callback — ปิดรายละเอียดแล้ว (ดู 9c) |
| ความสัมพันธ์กับระบบเดิม | เป็นโมดูลใหม่ที่เพิ่มเข้าไปใน `syndome-crm-mvc-ui`/`syndome-crm-api` (share DB, share role/menu mechanism) | **แยกขาดสมบูรณ์ (standalone)** — ไม่ share DB, ไม่ share auth, ไม่ share repo กับระบบเดิม (รายละเอียดหัวข้อ 7) |
| Repo | ใช้ repo เดิม 2 ตัว | **Repo ใหม่ (ชื่อ/จำนวน repo ยังไม่กำหนด — mono-repo หรือแยก UI/API ก็ได้ ดู 9b.6)** |

**ตารางเทียบชื่อ schema/ตาราง (เดิม → ใหม่)** — ใช้เทียบตอนอ่านประวัติการตัดสินใจในหัวข้อ 0/0b/9 ด้านบน (ยังอ้างชื่อชุดเดิมไว้เป็นประวัติ ไม่ได้แก้ย้อนหลัง) กับ schema จริงในหัวข้อ 6/ภาคผนวก A ด้านล่าง (ชื่อชุดใหม่):

| ชื่อเดิม (SQL Server) | ชื่อใหม่ (PostgreSQL, schema `project`) |
|---|---|
| `project.TMStatus` | `project.status` |
| `project.TMDealer` | `project.dealer` |
| `project.TMRunning` | `project.running_number` |
| `project.TTHProject` | `project.registration` |
| `project.TTDProjectEntry` | `project.entry` |
| `project.TTDProjectEntryRevision` | `project.entry_revision` |
| `project.TTDProjectEntryFile` | `project.entry_file` |
| `project.TTDProjectEntryProduct` | `project.entry_product` |
| `project.TTDProjectEntryTask` | `project.entry_task` |
| `project.TTDProjectStatusRequest` | `project.status_request` |
| `project.TTDProjectApproval` | `project.approval` |
| `project.TTLProjectStatusLog` | `project.status_log` |
| `project.TTNotification` | `project.notification` |
| `project.TMTeam` / `project.TMTeamUser` | `project.team` / `project.team_user` |
| `project.TMCompetitorBrand` / `project.TMOrgType` | `project.competitor_brand` / `project.org_type` |
| `project.TMLostReason` / `project.TMCollapseReason` | `project.lost_reason` / `project.collapse_reason` |
| `project.TMNotificationConfig` | `project.notification_config` |
| `TMRole` (ตารางของระบบเดิม) | **ไม่มีตารางเทียบ — role มาจาก JWT `roles` claim ของ SSO โดยตรง** (ปิดแล้ว ดู 9c/A.13) |
| `dbo.MTControl` (menu-control ของระบบเดิม) | ไม่มีของเดิมให้ reuse — ถ้าต้องการกลไกเปิด/ปิดเมนูจาก DB ต้องออกแบบใหม่ (ไม่บังคับ) |

**Naming convention ใหม่** (Postgres/Node idiom แทน PascalCase ของ .NET เดิม): ตาราง/คอลัมน์ใน DB ใช้ **`snake_case`** (`project_code`, `entry_sequence`, `is_current_revision`) ส่วน JSON payload ของ API/React ใช้ **`camelCase`** (`projectCode`, `entrySequence`) — แปลงกันที่ชั้น API (ORM หรือ mapping layer เล็กๆ) ไม่ผสมกันภายในชั้นเดียว

**อัปเดต 21 ก.ค. 2026 (รอบ 6):** ผู้ใช้ให้รายละเอียด SSO มาแล้ว (เอกสาร "SSO Management — App Integration Guide") — ปิดคำถาม 9b.1–9b.3 เกือบทั้งหมด รายละเอียดและผลกระทบต่อ schema/API/UI อยู่ที่หัวข้อ **9c** (ใหม่) — หัวข้อ 4.3, 5, 6.2, ภาคผนวก A.13, B ที่เคยเขียนไว้แบบ "รอข้อมูล SSO" ถูกปรับให้ตรงกับ 9c แล้วทุกจุด

---

## 0d. เพิ่มขอบเขตใหม่ — Mobile Responsive + แจ้งเตือนอนุมัติผ่าน LINE / Telegram (22 ก.ค. 2026 — เพิ่ม Telegram 30 ก.ค. 2026)

ผู้ใช้ขอเพิ่ม scope ใหม่ 2 เรื่อง ที่ **ไม่เคยมีใน Prototype เดิมเลย** (Prototype ทำมาเป็น desktop web + กระดิ่งแจ้งเตือนในแอปอย่างเดียว) — ต้องออกแบบเพิ่มทั้งหมด ไม่มีของเดิมให้ derive ต่างจากรอบ 5/6 ที่ยังมี Prototype/เอกสาร SSO ให้อ้างอิงชัดเจน:

| # | ความต้องการ (คำขอผู้ใช้) | แนวทางที่เอกสารนี้ใช้เขียนต่อ (สมมติฐาน — ยังไม่ยืนยัน) |
|---|---|---|
| 0d.1 | ใช้งานผ่านมือถือได้ | **Responsive web** — React SPA ชุดเดียวกัน ปรับ layout ตาม breakpoint (ไม่ใช่แอป native แยก, ไม่ใช่ codebase คนละชุด) — ถ้าที่จริงต้องการแอป native (ติดตั้งจาก App Store/Play Store) เป็นคนละงานที่ใหญ่กว่านี้มาก ต้องแจ้งแยกต่างหาก |
| 0d.2 | หน้ามือถือดูข้อมูลได้เหมือนหน้าจอ | **Feature parity แต่ไม่ใช่ layout parity** — ข้อมูล/ฟังก์ชันเดียวกันทุกอย่างผ่าน API endpoint เดียวกัน แต่จอที่มีตารางแน่น (ตาราง PM ตาม template — 18 คอลัมน์, ตารางเปรียบเทียบ Entry หลายคอลัมน์) ต้องออกแบบการแสดงผลใหม่สำหรับจอเล็ก ไม่ใช่ย่อตารางเดิมให้เล็กลงเฉยๆ (อ่านไม่ออก) |
| 0d.3 | แจ้งเตือนอนุมัติผ่าน LINE แบบ Flex Message **+ Telegram (เพิ่ม 30 ก.ค. 2026)** | ช่องทางแจ้งเตือน **เพิ่มเติม** จากกระดิ่งในแอป (ไม่ใช่แทนที่) — ผูก LINE Official Account (Messaging API) **และ Telegram Bot API** เข้ากับระบบ event notification ที่มีอยู่แล้ว (`project.notification`, ข้อ 9.24) ผ่าน **channel adapter ตัวเดียว** — รูปแบบข้อความต่างกันคนละชุด (LINE = Flex Message JSON / Telegram = HTML หรือ MarkdownV2 + inline keyboard) จึงต้องแยกชั้น template ต่อช่องทาง ไม่ hardcode (ดู 0g) |
| 0d.4 | ออกแบบสวยงาม เข้าใจงานง่าย | ผูกกับ design system ที่ยังไม่เลือก (9b.7) — เพิ่มเกณฑ์ "รองรับ mobile-first/responsive ในตัว" เป็นเกณฑ์เลือก design system ด้วย |

**ผลกระทบสรุปสั้น:** ไม่กระทบ business workflow/state machine ที่ปิดไปแล้ว (หัวข้อ 1, 9) แม้แต่น้อย — กระทบเฉพาะ **หัวข้อ 3** (สถาปัตยกรรม เพิ่ม LINE เป็น external integration ใหม่ + แก้ diagram ที่ค้าง SSO เก่า), **หัวข้อ 4** (UI — เพิ่ม 4.4 Responsive/Mobile), **หัวข้อ 5/6** (API/DB — LINE account-linking + dispatch service), **หัวข้อ 8** (ความเสี่ยงใหม่ 8.15–8.18), **หัวข้อ 9b** (คำถามคงค้างใหม่ 9b.11–9b.15), **หัวข้อ 10** (เพิ่มงาน), **ภาคผนวก A/B/D** (schema/endpoint/scenario ใหม่) — รายละเอียดอยู่ในแต่ละหัวข้อด้านล่าง

> ⚠️ **ระดับความแน่นอนของขอบเขตนี้ต่ำกว่ารอบ 5/6**: การ์ 5/6 มี Prototype และเอกสาร SSO เป็นแหล่งอ้างอิงที่เป็นลายลักษณ์อักษร ส่วนรอบนี้เขียนจากคำขอสั้นๆ ของผู้ใช้ล้วนๆ — สมมติฐานทุกจุดที่ทำเครื่องหมายไว้ด้านล่าง (โดยเฉพาะ 9b.11–9b.15) **ควรยืนยันกับผู้ใช้ก่อนเริ่ม implement จริง** ไม่ใช่แค่ก่อนปิด spec

---

## 0e. ~~เพิ่มขอบเขตใหม่ — AI Chat Assistant~~ → ✂️ **ตัดออกจากขอบเขตแล้ว (30 ก.ค. 2026)**

ขอบเขต **AI Chat Assistant** (FR-01–FR-11 ที่เพิ่มเข้ามารอบ 8) **ถูกตัดออกจากโครงการนี้ทั้งก้อน** ตามการตัดสินใจ 30 ก.ค. 2026 — ช่องทางแจ้งเตือน/สื่อสารที่เหลือคือ **push notification ผ่าน LINE และ Telegram เท่านั้น** (ดู 0d, 0g)

สิ่งที่ถูกถอดออกจากเอกสารพร้อมกัน: หัวข้อ 4.5 (chat widget), 6.5 + A.15 (`chat_session`/`chat_message`), endpoint 26/26b และ aggregate/stats endpoint ของ FR-07, ความเสี่ยงชุด chat (8.19–8.24 เดิม), คำถามค้าง 9b.16–9b.21, scenario D32–D35, และงาน 4 บรรทัดในหัวข้อ 10 (18–27 man-day) — **รายละเอียดฉบับเต็มยังอยู่ใน git history (commit `748d2bc` และก่อนหน้า)** ถ้ารื้อกลับมาทำภายหลังให้ดึงจากที่นั่น ไม่ต้องออกแบบใหม่ทั้งหมด

> หมายเหตุ: ความเสี่ยงเรื่อง "ข้อมูลต้นทุน/GP ถูกส่งออกไปยัง LLM ภายนอกองค์กร" (8.19 เดิม ระดับสูง) และคำถาม blocking เรื่อง LLM provider/DPA (9b.16 เดิม) **หมดไปพร้อมกับการตัดขอบเขตนี้** — ไม่ต้องประสานฝ่าย security เรื่องนี้อีก
---

## 0f. รอบ 10 (27 ก.ค. 2026) — ยึด Template Excel เป็นต้นแบบตาราง Project Management + ปิดคำถามจากรอบ review

รอบนี้ผู้ใช้ส่ง **`prototype/Template_ProjectManagement.xlsx`** (sheet `หลายรายการ` — ไฟล์ที่ทีมขายใช้กรอกงานจริง) มาให้ พร้อมตอบคำถามค้างจากรอบ review เอกสาร ผลคือ **ตาราง Project Management ถูกออกแบบใหม่ตาม template ทั้งชุด** (ภาคผนวก A.8 เขียนใหม่) ส่วนหน้าจออื่นไม่แตะ

| # | ประเด็นจาก review | ข้อสรุปรอบนี้ | จุดที่แก้ |
|---|---|---|---|
| 0f.1 | สูตร GP ในระบบไม่ตรงกัน (prototype คิด GP ไม่หัก EP / ข้อมูลหน้าเปรียบเทียบหัก EP / ช่อง GP ให้กรอกมือ) | **ยึด template:** `GP = ราคาขาย − ต้นทุน − EP`, `GP% = GP ÷ ราคาขาย × 100`, **GP ทุกช่องเป็นค่า derived ห้ามกรอกมือ** + **กติกา OC** (OC = Overriding Commission ค่าคอม Dealer — เป็นรายการหนึ่งใน EP): ระบบต้องมี GP 2 ชุด — **แถวสีขาว (spec line) = GP ก่อนหัก OC / แถวสีเทา (main + สรุป) = GP หลังหัก OC** ตามตัวเลขที่คำนวณจริงในไฟล์ (ต่างกันเท่าค่า OC พอดี — ดูตารางพิสูจน์ใน A.8.3.1) — **✅ ผู้ใช้ยืนยันทิศทางนี้แล้ว 27 ก.ค. 2026** | A.8 (เขียนใหม่ทั้งหัวข้อ), 1.1, 4.1, 6.1, C.3, D36 |
| 0f.2 | คอลัมน์/ระดับ record ของตาราง PM | **เอาตาม template ทุกคอลัมน์และทุกกลุ่มคอลัมน์**: 2 ระดับ (main item → spec line) + แถวสรุปโครงการที่คำนวณตอนแสดงผล — ไม่ใช่ 3 ระดับอิสระแบบ prototype; ยอดรวมระดับ Entry = ผลรวมของ main item เท่านั้น (ปิดคำถามเรื่อง roll-up/นับซ้ำ) — **และทุกช่องที่เป็นยอดรวมต้องรวมให้อัตโนมัติเหมือนสูตรใน Excel + read-only เมื่อ main item นั้นมีรายการย่อยอยู่ (A.8.3.2)** | A.8, 1.1, 4.1, 6.1, 4.4, 8.15, D36 |
| 0f.3 | ช่อง `รายการ`/Model ของตาราง PM มาจากไหน | **ดึงจาก ERP (item master) — น่าจะผ่าน API แต่ยังไม่สรุปกลไก จึงค้างไว้ก่อน** รอบนี้เตรียมคอลัมน์ `erp_item_code` ไว้เฉยๆ ยังกรอกมือได้เหมือน template | 9b.22 (ใหม่), A.8.2 |
| 0f.4 | Dealer อยู่ระดับ Project หรือ Entry (ตรวจซ้ำ 3 field ใช้ไม่ได้) | **Dealer อยู่ระดับ Entry ตามเดิม ถูกต้องแล้วตาม business** — ขาย B2B, Dealer หลายเจ้ามาขอราคางานเดียวกันได้ → **identity ของ Project = ชื่อหน่วยงาน + ชื่อโครงการ เท่านั้น (2 field)**, Dealer เป็นข้อมูลประกอบไว้เตือน/แสดงผล ไม่ใช่ key ตรวจซ้ำ | 1.1, A.4, B ข้อ 6, D5, D6 |
| 0f.5 | Entry ต่าง Dealer อาจเสนอราคาเท่ากัน | **ยอมรับได้ ไม่ต้องมี tie-break** — ป้าย "ต่ำสุด/สูงสุด/ดีที่สุด" ติดได้พร้อมกันหลาย Entry | 1.1, B ข้อ 7, D11 |
| 0f.6 | "แก้ไขข้อมูล" แก้ชื่อหน่วยงาน/ชื่อโครงการ ซึ่งเป็นข้อมูลระดับ Project ที่ทุก Entry ใช้ร่วมกัน | **เก็บ revision ระดับ Project ด้วย** — เพิ่มตาราง `project.registration_revision` คู่กับ revision ระดับ Entry ที่มีอยู่แล้ว | A.4b (ใหม่), 1.4, 9.23, B ข้อ 19b, D17 |
| 0f.7 | ฟอร์ม "ไม่ได้งาน → แพ้" ในหน้าจริงไม่มีช่อง "เหตุผลที่แพ้" (มีแต่ใน modal ที่เป็น dead UI) | **เก็บทั้ง 2 อย่าง: dropdown เหตุผลที่แพ้ (สำหรับรายงาน) + ช่องวิเคราะห์แบบ free text** → เพิ่ม dropdown เข้าไปในโซนอัพเดตสถานะของหน้า Detail | C.2, 1.4, A.9 (ไม่เปลี่ยน — รองรับอยู่แล้ว) |
| 0f.8 | ฟอร์ม "ได้งาน" ใน modal มีช่อง เลขที่ PO/สัญญา, มูลค่างาน, วันที่ได้งาน ที่ schema ไม่มีคอลัมน์รองรับ | **ไม่เพิ่ม field นอกเหนือจาก prototype ที่ใช้งานจริง** — ยึดชุด field ของโซนอัพเดตสถานะในหน้า Detail เท่านั้น (`#statusUpdateModal` ถือเป็น legacy ไม่ implement) | C.2 |

> **หลักการของรอบนี้:** หน้าจออื่นทั้งหมดใน prototype **ผ่านการ confirm กับผู้ใช้ปลายทางแล้ว — ไม่ปรับเพิ่ม/ไม่ redesign** ข้อสังเกตอื่นๆ จากรอบ review (เช่น งานเลยกำหนดไม่เข้ากระดิ่ง, filter วันคาดจบเป็นวันเดียว, dark mode) ให้ implement ตามพฤติกรรมของ prototype ไปก่อน ไม่ถือเป็นงานแก้ในรอบนี้ — **ยกเว้น 2 จุดที่ตัดสินใจเปลี่ยนไว้ข้างบน (ตาราง PM ทั้งตาราง และ dropdown เหตุผลที่แพ้)**

> ⚠️ **ผลต่อประมาณการงาน:** ตาราง PM ตาม template ซับซ้อนกว่าที่ประเมินไว้เดิม (roll-up 2 ระดับ + สูตร GP 2 ชุดตามกติกา OC + master EP item type + ผูก item จาก ERP) — ตัวเลขข้อ 10 บรรทัด "UI: ตาราง Project Management" (3–4 man-day) **ต้องทบทวนใหม่หลังปิด 9b.22** ยังไม่ปรับตัวเลขในรอบนี้เพราะยังไม่รู้ว่าต่อ ERP แบบไหน

---

## 0g. รอบ 11 (30 ก.ค. 2026) — ตัด AI Chat Assistant ออก + ช่องทาง push เหลือ LINE / Telegram

การตัดสินใจรอบนี้: **ตัดขอบเขต AI Chat Assistant (0e) ออกทั้งก้อน** และให้ช่องทางสื่อสารออกนอกระบบเหลือเพียง **push notification ผ่าน LINE และ Telegram** — ไม่มี LLM API อยู่ในสถาปัตยกรรมนี้อีก

| # | สิ่งที่เปลี่ยน | ผลกระทบ |
|---|---|---|
| 0g.1 | **ตัด AI Chat Assistant ออกทั้งชุด** (chat widget, chat orchestration, tool-use, conversation storage, aggregate/stats endpoint ของ FR-07) | ถอดออกจากเอกสารแล้วทุกจุด: 0e (ยุบเหลือหมายเหตุ), 4.5, 6.5, A.15, endpoint 26/26b, แถว chat ในหัวข้อ 5, ความเสี่ยง 8.19–8.24 เดิม, คำถาม 9b.16–9b.21, scenario D32–D35, งาน 4 บรรทัดในหัวข้อ 10 — **ความเสี่ยงระดับสูงสุดของโครงการ (ข้อมูลต้นทุน/GP ออกไปยัง LLM ภายนอก) และคำถาม blocking เรื่อง DPA หมดไปพร้อมกัน** |
| 0g.2 | **เพิ่ม Telegram เป็นช่องทาง push ที่ 2** คู่กับ LINE (ไม่ใช่แทนที่) | `auth.user` เพิ่ม `telegram_chat_id` + `push_channel_pref` (6.4/A.13), endpoint 25 เปลี่ยนเป็น `/notification/push/link` แบบระบุ channel, dispatch service ต้องรองรับ 2 ช่องทาง (หัวข้อ 5), scenario D31 ปรับให้ทดสอบทั้ง 2 ช่องทาง |
| 0g.3 | **ต้องทำเป็น channel adapter ไม่ใช่ hardcode ต่อช่องทาง** | รูปแบบข้อความคนละชุด (LINE = Flex Message JSON / Telegram = HTML หรือ MarkdownV2 + inline keyboard) — business logic ส่ง event + payload กลางชุดเดียว ให้ adapter ต่อช่องทาง render เอง เพื่อให้กติกา "เนื้อหาน้อยที่สุด" (8.18) บังคับได้ที่จุดเดียว และเพิ่มช่องทางที่ 3 ทีหลังไม่ต้องแตะ business logic (ความเสี่ยงใหม่ 8.20) |
| 0g.4 | **Telegram ต้องมีขา inbound ต่างจาก LINE** | การผูกบัญชี Telegram ต้องรับ `/start` จากฝั่ง Telegram (deep-link `https://t.me/<bot>?start=<token>`) = ต้องมี **webhook หรือ long-polling** ซึ่งแผนเดิม (LINE push ทางเดียว, 9b.14) ไม่มี — เป็นงาน infra + attack surface ใหม่ (ความเสี่ยงใหม่ 8.19, คำถามใหม่ 9b.24) |
| 0g.5 | **ผลต่อประมาณการงาน** | −18–27 man-day (chat ทั้ง 4 ก้อน) และ +2–3 man-day (Telegram adapter — ถูกกว่า LINE เพราะ dispatch service/ตาราง/หน้าผูกบัญชีใช้ร่วมกันแล้ว) → **~95–143 → ~79–119 man-day** และเหลือคำถาม blocking แค่ ORM (9b.4) + design system (9b.7) |

**สิ่งที่ไม่กระทบเลย:** business workflow / state machine / ตาราง Project Management ตาม template (0f) / Register / อนุมัติ 2 ชั้น / lifecycle / กระดิ่งในแอป — การตัด chat ไม่แตะ business logic ข้อใดเลย เพราะ chat ถูกออกแบบเป็นชั้นอ่านข้อมูลที่ห่อ endpoint เดิมอยู่แล้ว (ตามเจตนาเดิมใน 0e) และ Telegram เป็นช่องทาง delivery ไม่ใช่ระบบใหม่

> **ถ้าจะรื้อ chat กลับมาทำภายหลัง:** ดีไซน์ฉบับเต็ม (tool-use ผูก endpoint เดิม, บังคับ authorization ต่อ tool call, กัน hallucination, FR-01–FR-11) อยู่ใน git history commit `748d2bc` และ openspec design D11 เดิม — ไม่ต้องออกแบบใหม่ ให้ดึงกลับมาแล้วปิดคำถาม LLM provider/DPA ก่อนเริ่ม

---

## 1. สรุปฟีเจอร์จาก Prototype

โมดูลใหม่สำหรับ **ลงทะเบียนโครงการ (Project Register)** และ **บริหารต้นทุน/ราคาโครงการ (Project Management)** — ตาม updated-flow มี workflow อนุมัติ 2 ชั้น (หัวหน้าเซลล์ → Manager/พี่บี) แบ่งเป็น **3 Role**: Sales, หัวหน้าเซลล์ (HeadSale), Manager

### 1.1 หน้าจอฝั่ง Sales (`Role_Sale_Lastest.html`)

| หน้าจอ | ความสามารถหลัก |
|---|---|
| **ProjectRegister ALL** | รายการ Register ทุกทีม ค้นหา + filter ตาม status, **filter bar ใหม่: ทีม / Sales / วันคาดจบ + ปุ่มล้าง filter**, **sort ได้ 3 คอลัมน์: ทีม / Sales / วันคาดจบ (asc/desc)**, คอลัมน์ "จำนวน Entry", วันคาดจบ + จำนวนวันคงเหลือ (สีแดง/เหลือง/เขียว), กดดู Detail เข้าหน้าเปรียบเทียบ Entry |
| **To do list** | รายการเฉพาะ Account ตัวเอง + การ์ดสรุป 5 ใบ (ทั้งหมด / รออนุมัติ / โดน Reject / ใกล้ครบกำหนด <90 วัน / อนุมัติแล้ว) กดการ์ดเพื่อ filter |
| **อัพเดตสถานะ Register** | รายการของตัวเอง กดปุ่ม "อัพเดต Status" ได้เฉพาะสถานะ **นำเสนอ** → เปิดหน้า Detail แบบ read-only พร้อมโซนเลือกหัวข้ออัพเดต 4 แบบ: **ได้งาน / ไม่ได้งาน / เลื่อนวันคาดจบ / แก้ไขข้อมูล** แต่ละแบบมีฟอร์ม required + บันทึกร่างได้ → ส่งหัวหน้าอนุมัติ — **ใหม่: ฟอร์ม "ไม่ได้งาน" ให้เลือกก่อนว่า แพ้ หรือ ล่ม** (รายละเอียดข้อ 0.3 และ 1.4) |
| **ฟอร์ม Create/Edit Register** | ข้อมูลเซลล์ (ลำดับ auto, วันที่ auto, ทีม, Sales, แนบไฟล์เอกสารยื่นงาน, วันคาดจบ), รายละเอียดโครงการ (ชื่อหน่วยงาน, ชื่อโครงการ, ประเภทหน่วยงาน, Dealer จากฐานข้อมูล/Dealer ชั่วคราว, เงื่อนไขการขาย), **ปุ่มตรวจสอบข้อมูลซ้ำ**, ข้อมูลสินค้า (หลายรายการ), ระยะเวลารับประกัน, Bid Result (แสดงตอนอัพเดตสถานะ) |
| **ตรวจสอบข้อมูลซ้ำ** | **ปรับ 27 ก.ค. 2026 (0f.4): เทียบ 2 field เป็น key — ชื่อหน่วยงาน + ชื่อโครงการ** (normalize: trim/lowercase/ยุบช่องว่าง) — ตรงทั้ง 2 → เสนอให้ยื่นเป็น **Entry ลำดับถัดไป** ของ Project เดิม, ตรงบางส่วน → เตือนอย่างเดียว, กดดูรายละเอียด Project ที่ซ้ำได้ — **Dealer ไม่ใช่ key อีกต่อไป** (ขาย B2B: Dealer หลายเจ้าขอราคางานเดียวกันได้ → Dealer ต่างกันแต่เป็นงานเดียวกัน ต้องได้เป็น Entry ของ Project เดิม) แต่ยังแสดง Dealer ของ Entry ที่มีอยู่ในผลตรวจซ้ำเพื่อให้ Sales ตัดสินใจ |
| **Project Management (tab)** | **ปรับ 27 ก.ค. 2026 (0f.1/0f.2) — ยึด `Template_ProjectManagement.xlsx` แทนตารางใน prototype:** 2 ระดับ (**Main item → Spec line**) + **แถวสรุปโครงการ** ที่ระบบรวมให้เอง, คอลัมน์ตาม template: รายการ / Brand / Model / Q'ty / ต้นทุน @-Amt / EP รายการ-@-Amt / ราคาขาย @-Amt / GP @-Amt-% / ราคาขายคู่แข่ง รุ่น-@-Amt — **`GP = ราคาขาย − ต้นทุน − EP` เป็นค่า derived ห้ามกรอกมือ** และมีกติกา OC — GP 2 ชุด: **แถวขาว (spec line) = GP ก่อนหัก OC / แถวเทา (main + สรุป) = GP หลังหัก OC** — **ทุกช่องที่เป็นยอดรวมคำนวณให้อัตโนมัติเหมือนสูตรใน Excel และแก้ด้วยมือไม่ได้ เมื่อ main item นั้นมีรายการย่อยอยู่** — รายละเอียดสูตรครบทุกระดับ + สีพื้น/ชั้นการ group ดูภาคผนวก A.8 |
| **หน้าเปรียบเทียบ Entry** | Project 1 ตัวมีหลาย Entry (Entry ลำดับ 1 = เจ้าของ), tab เลือก Entry, ตารางเทียบข้อมูล Register ทุก Entry, เทียบ Project Management (ต้นทุน/EP/ราคาขาย/GP/GP% + ป้าย "ต่ำสุด/สูงสุด/ดีที่สุด" + BOM รายรายการ) เฉพาะ Entry ที่สถานะผ่านการอนุมัติแล้ว — ✅ 0f.5: **Entry ที่ราคา/GP เท่ากันเป๊ะเป็นเรื่องปกติ ติดป้ายพร้อมกันได้หลาย Entry ไม่ต้องมีกติกา tie-break**; ตัวเลขรวมของแต่ละ Entry = แถวสรุปโครงการตาม A.8.3 (รวมจาก main item เท่านั้น) |
| **เหตุผลการไม่อนุมัติ** | แสดงประวัติเหตุผล Reject จากหัวหน้า Sales (และช่องเตรียมไว้สำหรับ Supervisor/พี่บี) ในหน้า See Detail |
| **การแจ้งเตือน (กระดิ่ง)** | รายการโครงการที่วันคาดจบเหลือ < 90 วัน เรียงตามใกล้ครบกำหนด |

### 1.2 หน้าจอฝั่งหัวหน้าเซลล์ (`Role_HeadSale_Lastest.html`) — เพิ่มจากฝั่ง Sales

| หน้าจอ | ความสามารถหลัก |
|---|---|
| **To do list (เพิ่ม Approve Zone)** | การ์ดสรุปงานรออนุมัติ 5 ใบ: ทั้งหมด / Register+Management / ได้งาน / ไม่ได้งาน / เลื่อนวัน-แก้ไขข้อมูล |
| **อนุมัติ Project Register** | รายการรออนุมัติ filter ตามประเภท (Register+PM / ได้งาน / ไม่ได้งาน / เลื่อนวันคาดจบ / แก้ไขข้อมูล) |
| **หน้า Approval Detail** | ดูข้อมูล Register + Project Management + เปรียบเทียบทุก Entry ของ Project + ประวัติการพิจารณา → ปุ่ม **อนุมัติ** (modal ยืนยัน) / **ไม่อนุมัติ** (modal บังคับกรอกเหตุผล — เหตุผลไปแสดงฝั่ง Sales) — **อนุมัติ "ได้งาน/ไม่ได้งาน(แพ้)" แล้วส่งต่อ Manager** (`waitingWon → waitingSupervisorWon`, `waitingLost → waitingSupervisorLost`) ส่วนเลื่อนวัน/แก้ไขข้อมูลจบที่หัวหน้า |

### 1.2b หน้าจอฝั่ง Manager / พี่บี (`Role_Manager_Lastest.html`) — **ใหม่ทั้ง role**

| หน้าจอ | ความสามารถหลัก |
|---|---|
| ทุกหน้าของ Sales + หัวหน้า | Manager เห็นครบทุกหน้า และขอบเขตข้อมูล = **ทุก Project ในระบบ** (ไม่จำกัดทีม) |
| **อนุมัติ Project Register (ชั้น Manager)** | พิจารณาคำขอที่หัวหน้าอนุมัติแล้ว: `waitingSupervisorWon` → `won`, `waitingSupervisorLost` → `lost` (+ Reject → `rejected` พร้อมเหตุผล — แสดงในการ์ด "Supervisor/พี่บี" ฝั่ง Sales) — ✅ ขอบเขตชั้น Manager มีแค่ 2 สถานะนี้ (ข้อ 9.17 สรุปตาม HTML — Register ตั้งต้น/เลื่อนวัน/แก้ไขข้อมูล จบที่หัวหน้า) |
| **ระบุ Leader Project (เมนูใหม่)** | รายการ Project ที่มี Entry มากกว่า 1 + การ์ดนับ รอระบุ/ระบุแล้ว, เปิดหน้า detail เทียบทุก Entry (Register + PM + GP) แล้วเลือก 1 Entry เป็น **Leader** — ✅ สรุปข้อ 9.18: 1 Leader ต่อ Project, เลือกใหม่ = ย้าย, Entry อื่นไม่ถูกแตะสถานะ และยังแสดงใน compare ตามเดิม (การจัดเก็บปรับตาม review R4: `TTHProject.LeaderEntryID` คอลัมน์เดียวเป็น source of truth — flag ที่เห็นใน UI คำนวณจากค่านี้) |

### 1.3 สถานะ (Status) ทั้งหมด 13 สถานะ — ✅ คงเดิม ไม่เพิ่มสถานะใหม่ (สรุป 9.17/9.18 แล้ว)

`draft` (บันทึกร่าง), `waiting` (รออนุมัติ), `rejected` (โดน Reject — **หลังปรับ review R1 ใช้เฉพาะ Reject Register ตั้งต้น**), `presented` (นำเสนอ), `waitingPostpone`, `waitingEdit`, `waitingWon`, `waitingLost`, `waitingSupervisorWon`, `waitingSupervisorLost`, `won`, `lost`, `closed` (ปิดโครงการ — **ใช้งานจริงแล้วผ่านทาง "ล่ม"**)

> สถานะที่ flowchart PDF พูดถึงเพิ่ม สรุปแล้ว**ไม่ทำเป็นสถานะ**: "รอ Manager ระบุ Leader" → Leader เป็นแค่ flag (9.18), "รอ Manager อนุมัติ Register" → ไม่มี เพราะเอาตาม HTML ชั้นเดียว (9.17), "ยกเลิก" Entry ที่ไม่ใช่ Leader → ไม่ทำ Entry อื่นคงสถานะเดิม (9.18)

> **13 สถานะนี้เป็นสถานะระดับ Entry** — สถานะระดับ Project (`open/won/lost/closed` — ✅ ข้อ 9.22) เป็นค่า derived อีกชุดหนึ่ง ไม่นับรวมใน 13 ตัวนี้ (ดู 1.5) และสถานะของ**คำขอ** (RequestStatus ใน `TTDProjectStatusRequest`) ก็แยกอีกชุด (review R1 — ดู A.8)

### 1.4 State Machine (ตาม Prototype updated-flow — ทุก transition อยู่ใน Phase เดียว)

| จาก | เหตุการณ์ | ไป | หมายเหตุ |
|---|---|---|---|
| (ใหม่) | บันทึกร่าง (ระบบออก **ProjectCode** ตอนบันทึกครั้งแรกตาม design เดิม — SYS No. ยังไม่ทำ ข้อ 9.19) | `draft` | |
| `draft` / `rejected` | ส่งหัวหน้าอนุมัติ | `waiting` | Register + Project Management ต้องครบ |
| `waiting` | หัวหน้าอนุมัติ | `presented` | ✅ สรุปตาม HTML — ชั้นเดียวจบที่หัวหน้า (ข้อ 9.17) รวมถึง Entry ที่ join Project เดิมด้วย; การระบุ Leader เป็น flag แยกต่างหากไม่ใช่สถานะ (ข้อ 9.18) |
| `waiting` | หัวหน้า/Manager ไม่อนุมัติ | `rejected` | บังคับกรอกเหตุผล เก็บลงประวัติ (แยกการ์ดตาม role ฝั่ง Sales) |
| `presented` | Sales ส่ง "ได้งาน" (Bid Result ครบทุก field) | `waitingWon` | |
| `presented` | Sales ส่ง "ไม่ได้งาน" → เลือก **แพ้** (เหตุผลที่แพ้ + วิเคราะห์ + Bid Result) | `waitingLost` | เหตุผลที่แพ้: ราคา / Specification / ระยะเวลาส่งมอบ / เงื่อนไขการขาย / อื่นๆ |
| `presented` | Sales ส่ง "ไม่ได้งาน" → เลือก **ล่ม** (สาเหตุ + วันที่ปิด + รายละเอียด required) | `closed` | **ปิดโครงการทันที ไม่ผ่านการอนุมัติ** = End (ความเสี่ยง 8.9) |
| `presented` | Sales ส่ง "เลื่อนวันคาดจบ" (วันใหม่ + เหตุผล) | `waitingPostpone` | เก็บวันเดิมลง Log |
| `presented` | Sales ส่ง "แก้ไขข้อมูล" (หัวข้อ + ข้อมูลใหม่ + เหตุผล) | `waitingEdit` | |
| `waitingWon` | หัวหน้าอนุมัติ | `waitingSupervisorWon` | ✅ **Phase 1 แล้ว** (updated-flow ดึง Manager เข้ามา) |
| `waitingLost` | หัวหน้าอนุมัติ | `waitingSupervisorLost` | ✅ **Phase 1 แล้ว** เช่นเดียวกัน |
| `waitingSupervisorWon` | **Manager อนุมัติ** | `won` | End |
| `waitingSupervisorLost` | **Manager อนุมัติ** | `lost` | End |
| `waitingPostpone` | หัวหน้าอนุมัติ | `presented` | จบที่หัวหน้าชั้นเดียว (flowchart ไม่ส่งต่อพี่บี) — apply วันคาดจบใหม่ + log วันเดิม |
| `waitingEdit` (รอบคำขอ) | หัวหน้าอนุมัติคำขอแก้ไข | `presented` | ✅ ข้อ 9.23 — ระบบ clone **revision ร่าง** (`RevisionStatus='draft'`) ให้ Sales แก้เฉพาะหัวข้อที่ขอ — **ยังไม่ apply ข้อมูลใหม่** current revision ยังเป็นตัวเดิม — 🆕 **27 ก.ค. 2026 (0f.6): ถ้าหัวข้อที่ขอแก้เป็น ชื่อหน่วยงาน / ชื่อโครงการ / ประเภทหน่วยงาน → เปิด revision ระดับ Project (`registration_revision`, A.4b) แทน revision ระดับ Entry เพราะข้อมูลชุดนี้ทุก Entry ใช้ร่วมกันและเป็น key ตรวจซ้ำ** |
| `presented` (มี revision ร่าง) | Sales แก้เสร็จ ส่งอนุมัติ revision | `waitingEdit` | รอบที่ 2 — ใช้สถานะเดิม ไม่เพิ่มสถานะใหม่ (revision → `waiting`) |
| `waitingEdit` (รอบ revision) | หัวหน้าอนุมัติ revision | `presented` | revision ใหม่เป็น `current`, ตัวเดิม → `superseded` (เปิดดู read-only) — ✅ ข้อ 9.23: **ต้องผ่านอนุมัติซ้ำก่อนมีผล** |
| `waitingXxx` (คำขอเปลี่ยนสถานะทุกแบบ) | หัวหน้า/Manager ไม่อนุมัติ | `presented` | **ปรับตาม review R1 (19 ก.ค. 2026 — ทับข้อสรุป 9.1 เดิม):** Entry กลับ `presented` ส่วน**ตัวคำขอ**เป็น RequestStatus `rejected` พร้อมเหตุผล (แสดงการ์ดแยก role ฝั่ง Sales, การ์ด "โดน Reject" นับจากคำขอ) — Sales แก้แล้วส่งคำขอใหม่ได้ทันที; EntryStatus `rejected` คงใช้เฉพาะ Reject Register ตั้งต้น (`waiting → rejected`) |

### 1.5 Project-level lifecycle (ใหม่ — ✅ ข้อ 9.22, review R2)

สถานะระดับ Project เป็น **ค่า derived** เก็บใน `TTHProject.ProjectStatus` — ระบบคำนวณใหม่อัตโนมัติทุกครั้งที่ Entry เข้าสถานะปลายทาง ไม่มีจอให้ user กดเปลี่ยนเอง:

| ProjectStatus | เงื่อนไข (ประเมินตามลำดับบนลงล่าง) |
|---|---|
| `won` | มี Entry อย่างน้อย 1 ตัวสถานะ `won` |
| `lost` | ทุก Entry จบแล้ว (`lost`/`closed`) และมี `lost` อย่างน้อย 1 ตัว |
| `closed` | ทุก Entry เป็น `closed` (เช่น ล่มทั้งหมด) |
| `open` | นอกเหนือจากนั้น (ยังมี Entry active) — ค่าตั้งต้น |

- **หน้า list และแจ้งเตือนยึดข้อมูลราย Entry** ตาม Prototype (ทีม/Sales/วันคาดจบ = ของ Entry แถวนั้น) — `ProjectStatus` แสดงเป็น badge เสริมระดับ Project ในหน้า ALL และหน้า compare
- เมื่อ Project เข้า `won`/`lost`/`closed`: Entry อื่นคงสถานะเดิม (ตาม 9.18) แต่ **หยุดแจ้งเตือน near-due ทั้ง Project** และ server ปฏิเสธคำขอเปลี่ยนสถานะใหม่ของ Entry ที่เหลือ (กัน Entry แข่งกันหลังผลตัดสินแล้ว — ยืนยันรายละเอียดอีกครั้งตอน spec ได้)
- ทุกการเปลี่ยน `ProjectStatus` ลง log ใน `TTLProjectStatusLog` (แบบระบุ ProjectID — ดู A.10)

---

## 2. การตัดสินใจที่ยืนยันแล้ว (Confirmed 17 ก.ค. 2026)

| # | ประเด็น | ข้อสรุป |
|---|---|---|
| 1 | ขั้น Supervisor (พี่บี) | ~~**Phase ถัดไป**~~ → **ถูกยกเลิกโดย updated-flow 18 ก.ค. 2026** — พี่บี = Role "Manager" มี Prototype ของตัวเองแล้ว ขั้นอนุมัติ `waitingSupervisorWon/Lost → won/lost` และหน้าระบุ Leader **อยู่ใน scope รอบนี้ทั้งหมด** (ดูหัวข้อ 0.1, 1.2b) |
| 2 | Role หัวหน้าเซลล์ | **สร้าง role ใหม่** (`headsale`, `salemanager`) ในระบบใหม่ทั้งหมด — เดิมมีเงื่อนไข "ห้าม reuse role เดิมของระบบ CRM (`TMRole`)" แต่ตอนนี้**ไม่มีประเด็นนี้อีกต่อไป เพราะระบบแยกขาดจากกันโดยสมบูรณ์** (ไม่มี `TMRole` เดิมให้ปนอยู่แล้ว — moot by construction) — คงเหตุผลเชิง business ไว้: 2 role นี้ต้องแยกจากกันชัดเจน ไม่ปนกับ role อื่นใดในระบบใหม่ เพื่อคุม scope การอนุมัติ 2 ชั้นให้ถูกต้อง |
| 3 | ฐานข้อมูล Dealer | `project.dealer` เป็นตารางของระบบใหม่ทั้งหมด — เดิมมีเงื่อนไข "ไม่ reuse ตาราง Dealer ของโมดูล MA" แต่ตอนนี้**ไม่มีโมดูล MA อยู่ในระบบเดียวกันอีกต่อไป ประเด็น reuse จึงไม่เกิดขึ้นเองอยู่แล้ว** (standalone by construction) |
| 4 | สิทธิ์เห็นต้นทุน/GP | **ตาม Prototype** — Sales ทุกคนเห็นต้นทุน/GP ของทุก Entry ในหน้าเปรียบเทียบ (บันทึกเป็นความเสี่ยงข้อ 8.1) |

---

## 3. สถาปัตยกรรมใหม่และภาพรวมผลกระทบ (Re-platformed 21 ก.ค. 2026)

```
[React SPA]  ──HTTPS/JSON──▶  [Fastify API]  ──SQL (driver/ORM)──▶  [PostgreSQL]
 Responsive: desktop +         Node.js, plugin-based route/          schema `project`
 mobile breakpoint (0d.1)      handler, JSON Schema/Zod validation    (+ schema `auth`
 เรียก API ผ่าน fetch/axios    ต่อ endpoint                          สำหรับ auth.user)
     │                              │
     │                              ├──push Flex Message───────▶ [LINE Messaging API] ──▶ ผู้อนุมัติ (มือถือ)
     │                              └──push + inline keyboard──▶ [Telegram Bot API] ───▶ ผู้อนุมัติ (มือถือ)
     │                                   ผ่าน channel adapter ตัวเดียว (0d.3 / 0g)
     └── SSO Management (OAuth2 Authorization Code Flow, JWT RS256 — ปิดแล้ว ดู 9c) ──┘
              ยืนยันตัวตนก่อนเข้า React app และก่อนเรียกทุก API endpoint
```

- ฟีเจอร์นี้เป็น **ระบบใหม่ทั้งชุด แยกขาดจาก Syndome CRM เดิมโดยสมบูรณ์** — ไม่มี endpoint `AddProject/SearchProject` เดิมของ Quotation ให้ต้องกังวลอีกต่อไป (ข้อ 9.8 เดิม กลายเป็น moot — ดูหัวข้อ 9a)
- งานหลักแบ่ง 2 ส่วนเหมือนเดิมในเชิงโครงสร้าง (**UI / API**) แต่เปลี่ยนเป็น repo/โปรเจกต์ใหม่ทั้งคู่ (ยังไม่ตั้งชื่อ) — เสนอให้ตกลง **API contract ก่อน** เหมือนแนวทางเดิม เพื่อให้ UI/API พัฒนาขนานกันได้ (mock ได้จาก JSON Schema/OpenAPI ที่ Fastify generate ให้อัตโนมัติจาก route schema)
- **ข้อดีของการย้าย stack ที่ส่งผลต่อ design บางจุด** (รายละเอียดอยู่ในหัวข้อ 4–6 ที่เกี่ยวข้อง): Fastify มี `@fastify/multipart` รองรับไฟล์แนบในคำขอเดียวกันได้ตรงๆ (ไม่ต้องเลี่ยงผ่าน MVC action แบบเดิม), PostgreSQL รองรับ `STRING_AGG`/JSONB/`pg_trgm` ในตัว (ไม่มีข้อจำกัดแบบ SQL Server 2016)
- **(ใหม่ 22 ก.ค. 2026 — ปรับ 30 ก.ค. 2026 ดู 0g) LINE Messaging API + Telegram Bot API เป็น external integration ที่ระบบนี้พึ่งพานอกเหนือจาก SSO** — เป็น **push ออกทางเดียว** จาก Fastify (ไม่ใช่ identity provider, ไม่ใช่ที่เก็บข้อมูลธุรกิจ) ผ่าน **channel adapter ตัวเดียว** เพื่อไม่ผูก logic กับผู้ให้บริการรายใด — ข้อยกเว้นเดียวที่เป็น inbound คือขั้นตอนผูกบัญชี Telegram ที่ต้องรับ `/start` จากฝั่ง Telegram (ดู 0g.3, 9b.24) รายละเอียดที่หัวข้อ 5/6/8/9b
- **สิ่งที่ต้องตัดสินใจก่อนเริ่ม coding** — แยกเป็น 2 ระดับ (นิยามเดียวกับ 0g.5 และหัวข้อ 10 ลำดับงานข้อ 0/ข้อ 6):
  - **blocking ก่อนเขียนโค้ดบรรทัดแรก (2 ข้อ):** ORM/query layer (9b.4), design system/component library (9b.7) — 2 ข้อนี้กำหนดรูปแบบ migration script และโครงสร้าง UI ทั้งระบบ
  - **blocking เฉพาะก้อนงานของตัวเอง (ไม่กันงานอื่นเริ่ม):** responsive breakpoint/pattern ของตารางข้อมูลหนาแน่น (9b.11), LINE OA + Telegram bot + วิธีผูกบัญชีทั้ง 2 ช่องทาง (9b.12–9b.15, 9b.23–9b.25) — ต้องปิดก่อนเริ่มก้อน responsive/push, ที่เก็บไฟล์แนบ (9b.5) ต้องปิดก่อนเริ่มงาน upload
  - ทั้งหมดอยู่ในหัวข้อ 9b เป็นคำถามคงค้าง (SSO ปิดแล้ว ดู 9c)

---

## 4. ผลกระทบฝั่ง UI (React — repo ใหม่ ยังไม่ตั้งชื่อ)

### 4.1 โครงสร้างใหม่ (ประมาณการ)

| ประเภท | รายการ (ประมาณการ) |
|---|---|
| Pages/Routes | เทียบเท่า Controller เดิม 1 ต่อ 1 โดยประมาณ: `ProjectListPage` (ALL), `TodoListPage`, `StatusUpdateListPage`, `RegisterFormPage` (create/edit), `EntryDetailPage`, `ManagementTabPage`, `ComparePage`, `ApproveListPage`, `ApproveDetailPage`, `LeaderListPage`, `LeaderDetailPage` — ใช้ router ฝั่ง client (เช่น React Router) แทน MVC routing |
| Components | เทียบเท่า `_Partials/` เดิม: แถวสินค้า (`ProductRow`), แถว Task PM (`TaskRow` — main item / spec line ตาม A.8 + แถวสรุปที่คำนวณให้), `DealerModal`, `DuplicateCheckModal`, `ApprovalModal`, `SummaryCard`, `RejectReasonCard` (แยก head/supervisor), `LostPathCard` (แพ้/ล่ม) |
| State/data-fetching | เสนอ React Query/TanStack Query (หรือเทียบเท่า) คุม cache + loading/error state ของทุก endpoint — ไม่ต้อง reload เต็มหน้าแบบ MVC เดิม |
| Form handling | เสนอ React Hook Form + schema validation ฝั่ง client (เช่น Zod) ที่**ใช้ schema เดียวกับฝั่ง Fastify ได้ถ้าแชร์ package** (ลดโอกาส client/server validation ไม่ตรงกัน — ปัญหาเดิมที่ระบุไว้ในความเสี่ยง 8.7/9.14) |
| Styling/Design system | Prototype เดิมใช้ font Sarabun + CSS มือเขียนแบบ standalone (ไม่ใช่ theme "Sneat" ของระบบเดิมอีกต่อไป เพราะไม่ผูกกับระบบเดิมแล้ว) — **ต้องเลือก design system ใหม่สำหรับ React** (เช่น MUI, Ant Design, Chakra, หรือ Tailwind + component เขียนเอง) แล้วแปล UX จาก Prototype เข้าไป — ยังไม่ตัดสินใจ (ดู 9b.7) |
| Auto-calc logic | **ปรับ 27 ก.ค. 2026 (0f.1): ยึดสูตรตาม Template Excel ไม่ใช่ `calcRow` ของ prototype** — `Amt = Qty×@`, **`GP = ราคาขาย − ต้นทุน − EP`**, `GP% = GP ÷ ราคาขาย × 100`, roll-up spec line → main item → แถวสรุป และกติกา OC (ดู A.8.3 ครบทุกสูตร) — **ช่องที่เป็นยอดรวมต้อง auto + read-only และอัปเดตสดทันทีที่พิมพ์เหมือน Excel (A.8.3.2)** เขียนเป็น pure function ชุดเดียวใน React — **server ยังต้องคำนวณซ้ำเสมอเป็นค่าจริง** (หลักการเดิมไม่เปลี่ยน — ความเสี่ยง 8.7) — แนะนำแชร์ฟังก์ชันคำนวณเป็น package เดียวกับฝั่ง Fastify เพื่อไม่ให้สูตร 2 ฝั่งหลุดจากกัน |

### 4.2 จุดที่ Prototype กับสถาปัตยกรรมใหม่ต้องปรับตอน implement

1. **Pagination/ค้นหา/sort/filter** — เดิม Prototype ทำ client-side ทั้งหมด ระบบจริงควรทำ server-side ผ่าน query parameter ไปที่ Fastify (เช่น `?sortBy=team&sortDir=asc&team=...`) แล้ว query แบบ paginate ที่ PostgreSQL (`LIMIT/OFFSET` หรือ keyset pagination ถ้าข้อมูลโตมาก) — หลักการเดิมไม่เปลี่ยนจากตอนคิดบน SQL Server แค่เปลี่ยน syntax
2. **รายชื่อทีม 10 ทีม / sale1–sale20 / ยี่ห้อคู่แข่ง / ประเภทหน่วยงาน** hardcode ใน Prototype — ต้องเป็น master data จาก API เหมือนเดิม (ย้ายเป็น seed migration ของ PostgreSQL แทน `Deploy_SQL/` เดิม — ดูหัวข้อ 6)
3. ปุ่ม "บันทึก" ในกล่องข้อมูลสินค้า และปุ่ม footer ("บันทึกร่าง/รอหัวหน้าอนุมัติ") ใน Prototype ยังไม่มี logic จริง — ต้องกำหนด behavior ตอนทำ spec (ไม่เปลี่ยนจากเดิม) — **เพิ่ม 27 ก.ค. 2026: ช่อง `Amt` ในกล่อง "ข้อมูลสินค้า" ของ prototype เป็นช่องพิมพ์เปล่าๆ ไม่คำนวณให้ (`productTemplate` ไม่มี handler) → ให้ auto เป็น `Qty × @` + read-only ตามหลักการเดียวกับตาราง PM (A.8.3.2) เพื่อไม่ให้มีช่องเงินที่พิมพ์ทับได้หลงเหลือในระบบ**
4. **ไม่มี "แปลง theme" อีกต่อไป** (ข้อเดิมที่บอกว่าต้องแปลงจาก Sarabun ไปใช้ Sneat) — เพราะระบบใหม่ไม่มี theme เดิมให้ยึด ต้องออกแบบใหม่ทั้งชุด (เพิ่มงานเมื่อเทียบกับแผนเดิมที่ "มี theme อยู่แล้วแค่แปลง" — ดูผลต่อประมาณการงานหัวข้อ 10)

### 4.3 Auth ฝั่ง UI (ปิดตาม 9c)

- **ปุ่ม "เข้าสู่ระบบ"** เป็นแค่ลิงก์/redirect ไป `GET /auth/login` ของ Fastify เอง (ซึ่งข้างในต่อไป `GET {SSO_BASE_URL}/v1/oauth2/auth?...`) — **ไม่ต้องสร้างหน้าฟอร์ม username/password เอง** เพราะ SSO host หน้า login ให้ (คุม `state` ฝั่ง Fastify ไม่ generate ที่ browser)
- **Protected route wrapper**: ก่อน render ทุกหน้า เรียก endpoint เช็ค session ของเราเอง (เช่น `GET /auth/session`) — ไม่มี session ที่ใช้ได้ → redirect ไปปุ่ม login
- ตาม BFF pattern ที่แนะนำ (ดู 9c): **React ไม่ถือ SSO access/refresh token เอง** — Fastify เป็นคนคุย OAuth2 กับ SSO ทั้งหมด (callback/token exchange/refresh) แล้วออก **session cookie ของตัวเอง (httpOnly)** ให้ React แนบไปกับทุก request แทน — ลด attack surface และไม่ต้อง implement refresh-rotation logic ฝั่ง client
- **Logout**: ปุ่มในแอปเรียก endpoint logout ของ Fastify เอง (ข้างในไปเรียก `POST /v1/oauth2/logout` ต่อ + เคลียร์ session cookie)
- ทางเลือกอื่น (ส่ง SSO access_token ให้ React ถือแล้วแนบ Bearer เอง) ยังเป็นไปได้แต่ไม่แนะนำ — รายละเอียดเหตุผลและสถานะ (ยังไม่ blocking) ดู 9b.2/9c

### 4.4 Responsive / Mobile (ใหม่ 22 ก.ค. 2026 — ดู 0d.1/0d.2)

- **แนวทาง**: Responsive web ด้วย React ชุดเดียว (ไม่ใช่แอปแยก, ไม่ใช่ codebase คนละชุด) — ใช้ breakpoint ของ design system ที่เลือก (9b.7) กำหนด layout อย่างน้อย 2 ระดับ: desktop (≥ ~1024px) และ mobile (< ~768px) — ทุกหน้า render ได้ทั้ง 2 ระดับจาก component/route เดียวกัน ไม่ทำเป็นชุดหน้าแยกต่างหาก
- **จุดที่ต้องออกแบบใหม่จริงจัง** (ไม่ใช่แค่ CSS responsive ธรรมดา) เพราะ Prototype วางมาสำหรับตาราง desktop กว้างล้วนๆ:
  - ตาราง ProjectRegister ALL / To-do list / Approve list (คอลัมน์เยอะ) → บนมือถือควรเป็น **card list** ต่อแถวแทนตารางแนวนอน
  - ตาราง Project Management (2 ระดับ + แถวสรุป, 18 คอลัมน์ตาม template — A.8) → **จุดยากที่สุดของงานนี้** บนจอเล็กตารางกว้างขนาดนี้อ่านไม่ได้เลย ต้องคิด pattern ใหม่ (เช่น การ์ดต่อ task แสดงแบบ key-value + ยุบ/ขยายตามลำดับชั้น) — ยังไม่ออกแบบละเอียด เป็นงานออกแบบเพิ่มจริงจัง (ดูความเสี่ยง 8.15)
  - ตารางเปรียบเทียบ Entry (S6) — ปกติเทียบหลาย Entry เคียงข้างกัน บนจอเล็กอาจต้องเปลี่ยนเป็น tab สลับดูทีละ Entry แทนเทียบข้างกันทั้งหมด
- **Feature parity**: ไม่มีฟีเจอร์ไหนถูกตัดทิ้งสำหรับมือถือ (ตามคำขอ 0d.2) — เปลี่ยนแค่การแสดงผล ไม่เปลี่ยนข้อมูลที่เรียกจาก API (endpoint เดิมใช้ร่วมกันได้ทั้ง desktop/mobile ไม่ต้องแยก endpoint)
- **ยังไม่ตัดสินใจ**: breakpoint ที่แน่นอน, pattern การแสดงผลของตาราง PM/compare บนมือถือ (ต้องมี mockup/ทดสอบกับผู้ใช้จริงก่อน ไม่ใช่แค่เดา) — ดูคำถามใหม่ 9b.11

### 4.5 ~~AI Chat Assistant — Chat widget~~ → ✂️ ตัดออก (30 ก.ค. 2026 — ดู 0e/0g)

ไม่มี chat widget ในระบบนี้ — UI ที่เกี่ยวกับการแจ้งเตือนเหลือ **กระดิ่งในแอป** + **หน้าตั้งค่าโปรไฟล์สำหรับผูกบัญชี LINE/Telegram** (endpoint ข้อ 25) เท่านั้น

### 4.6 Mockup ต้นแบบหน้าจอมือถือ — AI Chat Assistant + LINE Push (เพิ่ม 23 ก.ค. 2026)

ทำ mockup แบบ static (HTML/CSS/JS ไฟล์เดียว ไม่ต่อ backend จริง) ขึ้นเองระหว่างงานนี้เพื่อสาธิตว่าหน้าตา/UX ของ 4.5 (Chat widget) และ 0d.3 (LINE push) จะเป็นอย่างไรบนมือถือจริง — ไฟล์: `updated-flow\ChatAssistant_Mobile_Prototype.html`

> ⚠️ **ข้อควรระวัง**: ไฟล์นี้เป็น **mockup ที่ทำขึ้นเองระหว่างงานนี้ ไม่ใช่ Prototype ที่ผู้ใช้ส่งมา** แบบชุด `Role_Sale_Lastest.html` ฯลฯ (ดู header table) — เป็นข้อเสนอเชิงภาพเพื่อให้เห็นรูปธรรมและเก็บ feedback เร็วขึ้นเท่านั้น **ยังไม่ผ่านการยืนยัน/อนุมัติจากผู้ใช้** และ **ไม่ได้ปิดคำถามค้างข้อใดเลย** (9b.16 LLM provider, 9b.17 retention, 9b.18 streaming, 9b.14 LINE one-way vs interactive ยังเปิดอยู่ทั้งหมด — mockup แค่แสดงภาพของสมมติฐานที่เอกสารนี้ใช้เขียนต่อไปก่อนเท่านั้น)

จัดเป็น 1 หน้าเว็บ มีปุ่มสลับ 2 หน้าจอย่อยในกรอบมือถือเดียวกัน:

| หน้าจอ | สาธิตอะไร |
|---|---|
| **🤖 AI Chat Assistant** | ชิปหัวข้อความสามารถ 11 ปุ่ม (ตรงกับ FR-01–FR-11) กดแล้วเล่นตัวอย่างบทสนทนาพร้อม typing indicator, การ์ดคำตอบแบบมีโครงสร้าง (header/body/footer คล้าย LINE Flex Message — ดู 4.5 เรื่องการ์ดแบบมีโครงสร้าง), ปุ่ม deep-link ทุกการ์ดเปิด bottom-sheet dialog จำลองหน้าที่จะถูกพาไป (แสดงหลักการ read-only ตาม 0e.9 — ปุ่มอนุมัติในหน้าจำลองถูก disable พร้อมข้อความอธิบาย) |
| **💬 LINE Push** | จำลองหน้าตาแอป LINE จริง (header/แชท/input bar ของ LINE เอง) ส่ง Flex Message ตัวอย่าง 4 แบบ (รออนุมัติใหม่/ใกล้ครบกำหนด/อนุมัติแล้ว/ไม่อนุมัติ) เนื้อหาในการ์ดจำกัดเฉพาะรหัสโครงการ + ประเภทคำขอตามความเสี่ยง 8.18 — กดปุ่มในการ์ดแล้วเห็น toast "กำลังออกจาก LINE" ก่อนเปิด preview หน้าเว็บภายนอก แสดงให้เห็นเป็นรูปธรรมว่าปุ่มใน Flex Message เป็น URI action เท่านั้น (ไม่มี dialog/การทำงานค้างอยู่ใน LINE เพราะยังไม่ทำ webhook/postback ตามสมมติฐาน 9b.14) |

> ✂️ **30 ก.ค. 2026:** หน้าจอย่อย "AI Chat Assistant" ใน mockup นี้ **ตกไปพร้อมกับการตัดขอบเขต chat (ดู 0e/0g)** — เหลือเฉพาะหน้าจอ "LINE Push" ที่ยังใช้เป็นต้นแบบได้ และใช้เป็นต้นแบบเนื้อหาของ Telegram ได้ด้วย (ต่างกันแค่ชั้น render) ตัวไฟล์ยังเก็บไว้ตามเดิมไม่ได้ลบ

**ขอบเขตที่ mockup นี้ยังไม่ครอบคลุม** (สำคัญ — อย่าตีความว่าปิดคำถามไปแล้ว): ไม่ได้แตะ pattern การ์ด/accordion ของตาราง PM (ตาม template) หรือตารางเปรียบเทียบ Entry บนมือถือ ซึ่งเป็นจุดยากที่สุดที่ยังไม่มี mockup อยู่ (9b.11 ยังเปิดอยู่เหมือนเดิม); ไม่ได้ตัดสินใจเรื่อง LLM provider/data policy (9b.16), streaming (9b.18), หรือ LINE interactive/postback (9b.14) — เป็นแค่ภาพประกอบของสมมติฐานที่มีอยู่แล้วในเอกสารนี้

---

## 5. ผลกระทบฝั่ง API (Node.js + Fastify — repo ใหม่ ยังไม่ตั้งชื่อ)

| ส่วน | รายละเอียด |
|---|---|
| โครงสร้าง route | 1 plugin ต่อโดเมนย่อย (Fastify plugin/encapsulation pattern) แทน 1 Controller เดิม เช่น `plugins/project-register/routes.js` — endpoint list เดิม (~20–26 endpoint, ดูภาคผนวก B) **ยังใช้ path เดิมได้เกือบทั้งหมด** เพราะเป็น REST path ทั่วไป ไม่ผูกกับ ASP.NET routing |
| Business logic layer | เทียบเท่า `IProjectRegisterService`/`ProjectRegisterService` เดิม — เสนอแยกเป็น service module ธรรมดา (function ล้วนหรือ class) เรียกจาก route handler, ไม่ผูกกับ Fastify request/reply object โดยตรง (testable แยกจาก HTTP layer) |
| Data access / ORM | **ยังไม่ตัดสินใจ (ดู 9b.4)** — ตัวเลือกทั่วไปสำหรับ Fastify+PostgreSQL: Prisma (migration tooling ครบ, type-safe, เขียนเร็ว), Drizzle ORM (เบากว่า ใกล้ SQL มากกว่า), Knex + `pg` (query builder ธรรมดา ไม่มี type-safety อัตโนมัติ) — ถ้าต้องการคำแนะนำ: **Prisma หรือ Drizzle** เหมาะกับทีมที่ต้องการ migration versioning ในตัว ใกล้เคียงกับที่ `Deploy_SQL/` เดิมเคยทำ (versioned script) |
| Validation | เสนอ JSON Schema หรือ Zod (ผ่าน `fastify-type-provider-zod`) ผูกกับทุก route — ได้ request validation + auto-generate OpenAPI/Swagger ในตัว (Fastify ทำให้ฟรีจาก schema) — **ยังต้อง validate rule ที่ prototype ทำแค่ฝั่ง JS ซ้ำฝั่ง server เหมือนเดิมทุกจุด** (Bid Result required fields, ล่ม ต้องมีสาเหตุ+วันที่+รายละเอียดครบ, transition ที่ถูกต้องเท่านั้น, กันส่งซ้ำ) — หลักการไม่เปลี่ยนจากเดิม |
| Auth middleware | Fastify `preHandler` hook verify JWT (RS256) ด้วย public key ของ SSO — เช็ค `exp`/`iss=sso-management`/`aud=<client_id ของเรา>` แล้วอ่าน `sub`/`roles` จาก payload (ปิดตาม 9c) — role-check ใช้ `roles.includes('headsale')` (เป็น array) ไม่ใช่ equality — หลักการเดิมยังคงไว้: **ตัวตน/สิทธิ์ของ actor อ่านจาก JWT ที่ verify แล้วเท่านั้น ห้ามเชื่อ field ที่ client ส่งมาเองใน body** (ต่อยอดจาก review R6) |
| SSO client (OAuth2) | Fastify ต้องมี: (1) route callback `GET /auth/callback` รับ `code`+`state`, เช็ค `state` กัน CSRF แล้วเรียก `POST {SSO_BASE_URL}/v1/oauth2/token` (server-to-server, **`application/x-www-form-urlencoded`** — ไม่ใช่ JSON — แนบ `client_secret`); (2) เก็บผลลัพธ์ (access/refresh token จาก SSO) ไว้ฝั่ง server แล้วออก **session cookie ของเราเอง** ให้ React ถือแทน (BFF pattern — ดู 9c); (3) refresh อัตโนมัติก่อน access token (SSO) หมดอายุ (900s) ผ่าน `POST /v1/oauth2/refresh` (refresh token ใช้ได้ครั้งเดียว ต้องเก็บอันใหม่ทุกครั้งที่ใช้); (4) endpoint logout เรียกต่อ `POST /v1/oauth2/logout` แล้วเคลียร์ session cookie; (5) **auto-provisioning** — ครั้งแรกที่ verify token สำเร็จ upsert แถวใน `auth.user` จาก claims (`sub`/`name`/`email`/`roles`) — ดู A.13 |
| ออกเลขรัน `ProjectCode` | ยังคง pattern เดิม (API เป็นคนออกเลขเสมอ, ป้องกัน race ด้วย transaction) — PostgreSQL ใช้ `SELECT ... FOR UPDATE` แทน `UPDLOCK` hint ของ SQL Server (พฤติกรรม row-lock เทียบเท่ากัน) |
| คำนวณ `ProjectStatus` (Project-level lifecycle) | หลักการเดิมทั้งหมด (ข้อ 9.22, หัวข้อ 1.5) — คำนวณใหม่ทุกครั้งที่ Entry เข้าสถานะปลายทาง, ไม่มีจอให้ user กดเปลี่ยนเอง |
| ไฟล์แนบ | **ง่ายขึ้นกว่าเดิม** — `@fastify/multipart` รับไฟล์ในคำขอเดียวกับข้อมูลฟอร์มได้ตรงๆ **ไม่ต้องเลี่ยงผ่าน MVC action แยกทางเหมือน review R7 เดิม** (ปัญหานั้นเกิดจากข้อจำกัดของ `HttpRequestHelper` ฝั่ง .NET ที่รองรับแค่ JSON — Fastify ไม่มีข้อจำกัดนี้) — ยัง**คงกติกาเดิม**ไว้ทั้งหมด: ชนิดเอกสาร/PDF, รวม ≤ 10 MB ต่อ revision, validate ฝั่ง server, rename ไฟล์กัน orphan |
| Event notification | หลักการเดิม (ข้อ 9.24) — 1 แถวต่อผู้รับ + read state — ส่วน "ยิง background job ตรวจวันใกล้ครบกำหนด" เดิมเสนอ ASP.NET `BackgroundServices` folder → **ของใหม่เสนอ scheduled job แยก process** (เช่น `node-cron` ในตัว API เอง สำหรับ workload เบา, หรือ queue/worker แยก เช่น BullMQ + Redis ถ้าปริมาณงานโต) — ยังไม่ตัดสินใจ ระดับนี้ยังไม่จำเป็นต้อง fix ตอนเขียน spec |
| **(ใหม่ 22 ก.ค. 2026 — ปรับ 30 ก.ค. 2026 ดู 0g) Push notification dispatch (LINE + Telegram)** | บริการใหม่ — ฟังเมื่อมีแถวใหม่ใน `project.notification` ที่เป็นเหตุการณ์ที่เลือกให้ push (ดู 9b.15) แล้วยิงออกตาม**ช่องทางที่ผู้รับผูกไว้**: LINE Messaging API `POST /v2/bot/message/push` (Flex Message) และ/หรือ Telegram Bot API `POST /bot{token}/sendMessage` (HTML/MarkdownV2 + inline keyboard URL button) — ต้องมี mapping ผู้ใช้↔LINE `userId` / Telegram `chat_id` ก่อน (ดู 6.4/9b.13/9b.24) — **จัดเป็น channel adapter: business logic รู้แค่ "ส่ง event นี้ให้ user นี้" ส่วนการ render ข้อความและการเรียก API เป็นหน้าที่ของ adapter ต่อช่องทาง** — เป็น **push ทางเดียว** (ไม่มี logic รับ postback action จาก LINE ในสมมติฐานตอนนี้ — ดู 9b.14) — ควรทำเป็น service แยกเรียกจาก event-notification service เดิม (asynchronous, ไม่ผูกกับ HTTP request ที่ trigger event) กัน response ของ API ช้าเพราะรอ LINE API ตอบ + ต้อง handle เคส push ล้มเหลว/quota เกินแบบ silent (ไม่ทำให้ event หลักในระบบล้มเหลวตาม — กระดิ่งในแอปต้องยังขึ้นแม้ LINE push ไม่สำเร็จ) |
| **(ใหม่ — ปรับ 30 ก.ค. 2026) Account linking (LINE / Telegram)** | endpoint ใหม่ให้ user ผูกบัญชีของตัวเองกับ `auth.user` — LINE (กลไกยังไม่เลือก ดู 9b.13) และ Telegram (**ต้องรับ `/start` ที่มี token จากฝั่ง Telegram = ต้องมี webhook หรือ long-polling ต่างจาก LINE ที่ push ทางเดียวพอ** ดู 9b.24) — ถ้ายังไม่ผูกช่องทางใดเลย จะไม่ได้รับ push แต่กระดิ่งในแอปยังทำงานปกติ (ไม่ผูกกัน) |

---

## 6. ผลกระทบฐานข้อมูล (PostgreSQL)

### 6.1 ตารางใหม่ (schema `project`, ตั้งชื่อใหม่ทั้งหมดตาม snake_case — ดูตารางเทียบชื่อในหัวข้อ 0c)

| ตาราง | ชนิด | เก็บอะไร |
|---|---|---|
| `project.status` | Master | 13 สถานะระดับ Entry + ลำดับ + สี badge — คงเดิมไม่เพิ่มสถานะใหม่ (ข้อ 9.17/9.18 — ยังใช้ได้) |
| `project.dealer` | Master | Dealer ของระบบนี้: ชื่อ, ที่อยู่, จังหวัด/อำเภอ/ตำบล/ไปรษณีย์, `is_temporary` (Dealer ชั่วคราว), ผู้สร้าง — **ข้อมูลภูมิศาสตร์ต้องหาแหล่งใหม่เอง** เพราะเดิมเคย reuse lookup API ของ `syndome-crm-api` — ตอนนี้ standalone แล้วไม่มีให้ reuse (ดูความเสี่ยง 8.13 / 9b.8) |
| `project.running_number` | Master | เลขรัน `PRJ-YYYY-MM-XXXX` reset รายเดือน (ข้อ 9.11 — หลักการเดิม) |
| `project.registration` | Trans (Header) | 1 แถว = 1 Project: `project_code`, ชื่อหน่วยงาน, ชื่อโครงการ, ประเภทหน่วยงาน, **`project_status` (`open/won/lost/closed` — Project-level lifecycle ข้อ 9.22)**, **`leader_entry_id`** (Entry ที่ Manager เลือกเป็น Leader) + คอลัมน์ normalized สำหรับตรวจซ้ำ |
| `project.entry` | Trans | identity คงที่ของ Entry — 1 แถว = 1 Entry ตลอดชีวิต: FK Project, `entry_sequence` (1 = เจ้าของ), `entry_code`, Sales เจ้าของ, สถานะ workflow (`status_id`), audit — **UNIQUE (project_id, entry_sequence)**; ข้อมูลฟอร์มอยู่ตาราง revision |
| `project.entry_revision` | Trans | ข้อมูลฟอร์มราย revision: `revision_no`, `revision_status` (draft/waiting/current/superseded), `is_current_revision`, ทีม, Dealer, เงื่อนไขการขาย, วันคาดจบ, ประกัน — unique partial index คุม current 1 แถวต่อ Entry; ตารางลูก File/Product/Task ผูกกับ revision |
| `project.entry_file` | Trans | ไฟล์แนบหลายไฟล์ต่อ revision (เอกสาร/PDF, รวม ≤ 10 MB) — ที่เก็บไฟล์จริง (disk path หรือ object storage key) **ยังไม่ตัดสินใจ (ดู 9b.5)** |
| `project.entry_product` | Trans | สินค้าใน revision: Model, Group, ชนิดแบต, Qty Batt, Batt Bank, Option, Qty, @, Amt |
| `project.entry_task` | Trans | ตาราง Project Management (ผูกกับ revision) — **ยึด Template Excel (0f.2):** `parent_task_id` (self-FK; ใช้จริง 2 ระดับ main→spec), รายการ, Brand, Model, Qty, ต้นทุน @/Amt (+ วันที่อ้างอิงราคาทุน), EP รายการ/@/Amt (+ ชนิด EP/OC + วันที่-แหล่งที่มาราคา), ราคาขาย @/Amt, **GP @/Amt/% (derived)**, ราคาขายคู่แข่ง รุ่น/@/Amt — รายละเอียดครบดู A.8 |
| `project.ep_item_type` | Master | **(ใหม่ 27 ก.ค. 2026)** ชนิดรายการ EP (ค่าขนส่ง, **OC = Overriding Commission / Outside Commission — ค่าคอมจ่าย Dealer**) + flag `is_oc` — ใช้แยกว่ารายการ EP ไหนต้องถูกหักใน GP ชุด "หลังหัก OC" เท่านั้น (A.8.3.1) |
| `project.status_request` | Trans | คำขอเปลี่ยนสถานะ (won/lost/postpone/edit): ประเภท, payload, `request_status` แยกจากสถานะ Entry (review R1), `is_draft` + กลุ่ม `lost_type`/`lost_reason_id`/`collapse_reason_id`/`collapse_date`/`collapse_note` |
| `project.approval` | Trans | ประวัติพิจารณา: ผู้อนุมัติ, role (head/supervisor), อนุมัติ/ไม่อนุมัติ, เหตุผล, ประเภทการ approve, วันที่ |
| `project.status_log` | Trans | Log ทุกการเปลี่ยนสถานะระดับ Entry และระดับ Project (จาก → ไป, โดยใคร, เมื่อไร) |
| `project.notification` | Trans | event notification (เริ่มที่ event ปิดแบบ "ล่ม") 1 แถวต่อผู้รับ + `is_read` |
| `project.team` / `project.team_user` | Master | ทีมขาย + matrix ผูก user↔ทีม และหัวหน้า↔ทีมแบบ 1-M |
| `project.competitor_brand` / `project.org_type` | Master | ยี่ห้อคู่แข่ง / ประเภทหน่วยงาน — config ให้ admin จัดการได้ |
| `project.lost_reason` / `project.collapse_reason` | Master | เหตุผลที่แพ้ / สาเหตุที่โครงการล่ม |
| `project.notification_config` | Master | เกณฑ์วันแจ้งเตือน (config ได้) + ช่อง Webhook URL เผื่ออนาคต (ยิงจริง pending) |

### 6.2 role/auth — ปิดแล้ว (ดู 9c)

เดิมหัวข้อนี้คือ "การเปลี่ยนแปลงตารางเดิม" (`TMRole`, `dbo.MTControl` ของระบบเดิม) — **ตอนนี้ไม่มีตารางเดิมให้แก้แล้ว เพราะ standalone** ที่เก็บ role/สิทธิ์: **ไม่มีตาราง role local** — role มาจาก JWT `roles` claim ของ SSO โดยตรง (SSO admin ตั้งค่า `group_role_map` เฉพาะ client_id ของระบบนี้ให้ map AD group → role string ที่เราต้องการ: `sales`/`headsale`/`salemanager`/`admin`) สิ่งที่ต้องมีเพิ่มแทนคือตาราง **`auth.user`** — cache/provisioning record สร้างอัตโนมัติตอน login ครั้งแรก (auto-provisioning ตามเอกสาร SSO) เก็บ `username` (=`sub`), `display_name`, `email`, `roles` (snapshot ล่าสุด) ไว้ join แสดงผล (ชื่อผู้อนุมัติ, เจ้าของ Entry ฯลฯ) โดยไม่ต้องเรียก SSO ซ้ำทุกครั้ง — **ไม่ใช่ authority ของสิทธิ์** (สิทธิ์อ่านจาก JWT ของ request นั้นๆ เสมอ ไม่อ่านจาก cache นี้) รายละเอียดคอลัมน์ดู A.13

### 6.3 ข้อดี/ข้อควรระวังเฉพาะ PostgreSQL

- **ข้อดีเทียบกับ SQL Server 2016 เดิม:** `STRING_AGG` ใช้ได้ตรงๆ (ไม่ต้องเลี่ยงด้วย `STUFF+FOR XML PATH` แบบเดิม), มี `JSONB` ถ้าต้องเก็บ payload แบบยืดหยุ่น (เช่น audit snapshot), extension `pg_trgm` ทำ fuzzy/partial match ได้ดีกว่า `LIKE` เดิมที่เสนอไว้สำหรับความเสี่ยง 8.4 (ตรวจซ้ำแบบ exact-match พิมพ์ต่างกันเล็กน้อยจะหลุด) — **แนะนำเปิด `pg_trgm` ตั้งแต่ต้นแล้วใช้ `similarity()`/`%` operator แทน `LIKE` ธรรมดา เพิ่มคุณภาพการตรวจซ้ำได้โดยไม่ต้องรอ phase หน้า**
- Auto-increment PK: ใช้ `GENERATED ALWAYS AS IDENTITY` (มาตรฐานใหม่ แทน `SERIAL` แบบเก่า)
- Money: `NUMERIC(18,2)` (เทียบเท่า `DECIMAL(18,2)` เดิม)
- Boolean: `BOOLEAN` (แทน `BIT`)
- วันที่เวลา: **`TIMESTAMPTZ` เสมอ** (ไม่ใช้ `TIMESTAMP` เฉยๆ) กัน bug เรื่อง timezone ตั้งแต่ต้น — ต่างจาก `DATETIME2` เดิมที่ไม่มี timezone
- ข้อความ: ใช้ `TEXT` เป็นค่าเริ่มต้น (Postgres ไม่มีข้อได้เปรียบเชิง performance จากการจำกัดความยาวแบบ `VARCHAR(n)`) ยกเว้น field ที่มีรูปแบบตายตัวจริงๆ เช่น `project_code VARCHAR(20)`
- การตรวจซ้ำ: ยังคงแนวทางเดิม (เก็บคอลัมน์ normalized เป็น `GENERATED ALWAYS AS (...) STORED` + index) — เรื่อง collation ภาษาไทยที่เคยกังวล (`Thai_CI_AS`) ไม่ใช่ปัญหาแล้วเพราะ normalize เป็น lowercase ไว้ในคอลัมน์ก่อนเทียบอยู่แล้ว (ไม่ได้พึ่ง collation ของ DB ในการเทียบ case-insensitive)
- Migration/versioning: เสนอใช้เครื่องมือ migration ของ ORM ที่เลือก (Prisma Migrate / Drizzle Kit / node-pg-migrate) แทนโฟลเดอร์ `Deploy_SQL/<วันที่>/` เดิม — ยังไม่ตัดสินใจเครื่องมือ (ดู 9b.4)

### 6.4 Push channel binding — LINE / Telegram (ใหม่ 22 ก.ค. 2026 — เพิ่ม Telegram 30 ก.ค. 2026 ดู 0d.3/0g)

เพิ่มคอลัมน์บน **`auth.user`** (ไม่ใช่ตารางใหม่ — ผูกกับ user ที่ provision จาก SSO อยู่แล้ว):

| คอลัมน์ | เก็บอะไร |
|---|---|
| `line_user_id TEXT NULL UNIQUE` | LINE `userId` (ค่าภายในของ LINE เอง ไม่ใช่ LINE ID ที่ user ตั้ง ไม่ใช่เบอร์โทร) หลังผ่านขั้นตอนผูกบัญชี — `NULL` = ยังไม่ผูก |
| `telegram_chat_id TEXT NULL UNIQUE` | Telegram `chat_id` ของ user (ได้จากตอน user กด `/start` คุยกับ bot) — `NULL` = ยังไม่ผูก |
| `push_channel_pref TEXT NULL` | ช่องทางที่ user อยากรับ (`line` / `telegram` / `both`) — ค่าเริ่มต้นคือส่งทุกช่องทางที่ผูกไว้ (ดูคำถาม 9b.25) |

- ไม่ผูกช่องทางใดเลย = ไม่ได้รับ push (กระดิ่งในแอปไม่กระทบ) — UI ต้องเตือนให้ชัด ไม่ใช่เงียบไป (ความเสี่ยง 8.17)
- **ยังไม่ตัดสินใจ:** ต้องมีตาราง log สถานะการส่งแยกหรือไม่ (สำเร็จ/ล้มเหลว/เกิน rate limit ต่อข้อความ ต่อช่องทาง) — ขึ้นอยู่กับว่าต้องการหน้าจอตรวจสอบ delivery หรือ best-effort พอ (ดู 9b.15)
- **23 ก.ค. 2026:** มี mockup หน้าตา Flex Message ที่จะ push จริงแล้ว (self-authored ดู 4.6) — ช่วยยืนยันภาพ "เนื้อหาน้อยที่สุด" ตามความเสี่ยง 8.18 ให้เป็นรูปธรรม ใช้เป็นต้นแบบเนื้อหาของ Telegram ได้ด้วย (เปลี่ยนแค่ชั้น render) แต่ยังไม่ปิดคำถาม 9b.12–9b.15/9b.24 ข้อใด

### 6.5 ~~AI Chat Assistant — conversation storage~~ → ✂️ ตัดออก (30 ก.ค. 2026 — ดู 0e/0g)

ไม่มีตาราง `chat_session`/`chat_message` ในระบบนี้ — และไม่มีข้อมูลอ่อนไหวชุดใหม่ที่ต้องกำหนดนโยบาย retention เพิ่มจากที่มีอยู่แล้ว

---

## 7. ผลกระทบต่อระบบ Syndome CRM เดิม

**ไม่มี** — ระบบนี้แยกขาดจาก Syndome CRM เดิมโดยสมบูรณ์ตามการตัดสินใจ 21 ก.ค. 2026 (ไม่ share DB, ไม่ share auth/role mechanism, ไม่ share repo/deploy pipeline) จุดที่เคยต้องพิจารณาผลกระทบในรอบก่อน (เมนู sidebar, ระบบ Login/JWT เดิม, User Management เดิม, To Do List กลางเดิม) **ไม่มีทางเกิดขึ้นได้อีกต่อไปเพราะไม่ได้อยู่ในโค้ด/ระบบเดียวกัน**

จุดเดียวที่ยังอาจเกี่ยวข้องกับ "ของเดิม" คือถ้า SSO provider เป็นตัวเดียวกับที่ระบบอื่นในองค์กรใช้อยู่ (เช่น ผู้ใช้ login คนเดียวกันเข้าได้ทั้ง Syndome CRM เดิมและระบบใหม่นี้) — นั่นคือความเกี่ยวข้องระดับ **identity provider เท่านั้น ไม่ใช่ระดับโค้ด/ฐานข้อมูล** และยังไม่ทราบรายละเอียด (ดู 9b.1)

---

## 8. ความเสี่ยงและข้อเสนอแนะ

| # | ความเสี่ยง | ระดับ | ข้อเสนอ |
|---|---|---|---|
| 8.1 | ต้นทุน/GP เปิดให้ Sales ทุกคนเห็น (ยืนยันแล้วว่าทำตาม Prototype) — ข้อมูลอ่อนไหวเชิงธุรกิจ | สูง | เหมือนเดิม: บันทึกการตัดสินใจไว้เป็นลายลักษณ์อักษร, เก็บ audit log การเข้าดูหน้า compare, ออกแบบ response ให้ตัด cost/GP ออกได้ง่ายถ้านโยบายเปลี่ยน (ที่ชั้น Fastify route/service เดียว) |
| 8.2 | Reject คำขอ won/lost/postpone/edit — แก้แล้วตาม review R1 (Entry กลับ `presented`, คำขอเป็น `rejected`) — หลักการนี้ไม่เปลี่ยนจาก stack ใหม่ | ต่ำ | เหมือนเดิม (เก็บ `ref_request_id` ใน `status_log`) |
| 8.3 | Race condition ออกเลข Entry ลำดับถัดไปพร้อมกัน 2 คน | กลาง | Transaction + UNIQUE constraint เหมือนเดิม — PostgreSQL ใช้ `SELECT ... FOR UPDATE` แทน `UPDLOCK` |
| 8.4 | ตรวจซ้ำแบบ exact-match พิมพ์ต่างกันเล็กน้อยจะหลุด | กลาง | **ดีขึ้นกว่าเดิมได้ง่ายๆ** — PostgreSQL มี `pg_trgm` ในตัว ใช้ `similarity()` แทน `LIKE` ธรรมดาได้ตั้งแต่ phase แรกโดยไม่ต้องรอ phase หน้าแบบที่เอกสารเดิมเสนอ |
| 8.5 | ไฟล์แนบ — ที่เก็บไฟล์จริงยังไม่ตัดสินใจ (disk ของ API server vs object storage) | กลาง | ถ้าเลือก disk ยังมีความเสี่ยงเดิม (หายตอน redeploy, ไม่ redundant) เหมือนระบบเดิมทุกประการ — **แนะนำพิจารณา object storage (S3-compatible) ตั้งแต่ต้น** เพราะเป็นระบบใหม่ ไม่มี pattern เดิมผูกไว้แล้ว — ตัด pain point "ต้อง backup โฟลเดอร์ Upload" ไปได้ทั้งหมด (ดู 9b.5) |
| 8.6 | "แก้ไขข้อมูล Register" เป็น revise version ใหม่ — ทุกตารางลูกต้องผูกกับ revision | กลาง–สูง | หลักการเดิมทั้งหมด (แยก `entry`/`entry_revision`, unique partial index คุม current, สลับ current ใน transaction เดียว) — ไม่เปลี่ยนจาก stack ใหม่ เพราะเป็น data-model pattern ไม่ใช่เรื่องภาษา/framework |
| 8.7 | ตาราง PM (roll-up 2 ระดับตาม template) + คำนวณเงินฝั่ง client — ปัดเศษ/ทศนิยมไม่ตรงกับฝั่ง server | ต่ำ–**กลาง (ปรับขึ้น 27 ก.ค. 2026)** | กำหนดกติกา `NUMERIC(18,2)` + server คำนวณซ้ำเป็น source of truth เหมือนเดิม — **เพิ่มความเสี่ยงจากรอบนี้: สูตรมีหลายชั้น (spec→main→สรุป) และ GP มี 2 แบบตามกติกา OC → ถ้า React กับ Fastify implement คนละที่จะเพี้ยนกันได้ง่ายกว่าเดิมมาก แนะนำแชร์ฟังก์ชันคำนวณเป็น package เดียว + มี unit test เทียบกับตัวเลขในไฟล์ template โดยตรง (D36)** |
| 8.8 | ขอบเขต 2 ส่วน (UI/API) — เริ่มพัฒนาขนานไม่ได้ถ้าไม่มี contract ก่อน | ต่ำ | เหมือนเดิม: ตกลง API contract ก่อน (ภาคผนวก B) แล้วพัฒนาขนานด้วย mock — Fastify generate OpenAPI จาก schema ได้ ช่วยเรื่องนี้ได้ดีกว่าเดิมด้วยซ้ำ |
| 8.9 | "ล่ม" ปิดโครงการ (`closed`) ได้ทันทีโดยไม่ผ่านการอนุมัติใคร | กลาง–สูง | หลักการเดิมทั้งหมด (บังคับกรอกครบ + log + event notification ข้อ 9.24) — ไม่เปลี่ยนจาก stack ใหม่ |
| 8.10 | ขั้นอนุมัติ 2 ชั้นทำให้ lead time ยาวขึ้น ถ้า Manager ไม่อยู่งานค้าง | กลาง | เหมือนเดิม (การ์ด/แจ้งเตือนชัด + พิจารณา assign role Manager มากกว่า 1 คน) |
| 8.11 | ~~Auth/authorization ทั้งชุดยังปิด spec ไม่ได้จนกว่าจะรู้รายละเอียด SSO~~ → **ปิดแล้ว (ดู 9c) — ความเสี่ยงใหม่แทนที่:** ระบบนี้ผูกความพร้อมใช้งานของ "login" ทั้งหมดไว้กับ SSO Management + Active Directory ส่วนกลาง — ถ้า LDAP ล่ม ไม่มี local password fallback (gotcha ของ SSO เอง) → login ไม่ได้ทั้งองค์กร ไม่ใช่แค่ระบบนี้ | กลาง | ไม่ใช่ความเสี่ยงที่ระบบนี้แก้เองได้ (เป็น SPOF ระดับองค์กร) — บันทึกไว้เป็นข้อจำกัดที่รับทราบร่วมกัน, ถ้ากังวลเรื่อง SLA ควรถามทีม SSO เรื่อง uptime target/redundancy ของ AD |
| 8.12 | **(ใหม่) ทีมอาจไม่มีประสบการณ์ Node/Fastify/React/Postgres เท่ากับ .NET/SQL Server เดิม** — ยังไม่ทราบ ไม่ได้ระบุ | ไม่ทราบ | ถ้าเป็นทีมเดิมที่ถนัด .NET มาก่อน ควรกันเวลาช่วง ramp-up ไว้ในประมาณการงาน (หัวข้อ 10) — ต้องยืนยันจากผู้ใช้ |
| 8.13 | **(ใหม่) ต้องหาแหล่งข้อมูลภูมิศาสตร์ไทย (จังหวัด/อำเภอ/ตำบล/ไปรษณีย์) ใหม่** เพราะเดิม reuse lookup API ของ `syndome-crm-api` ได้ฟรี ตอนนี้ standalone แล้วไม่มีให้ reuse | ต่ำ–กลาง | มี dataset เปิดสาธารณะสำหรับข้อมูลจังหวัด/อำเภอ/ตำบลไทยหลายแหล่ง เลือก seed เข้า PostgreSQL ตอนตั้งระบบครั้งแรก |
| 8.14 | **(ใหม่)** SSO ไม่มี JWKS endpoint — public key สำหรับ verify JWT ต้องได้รับแบบ manual (copy ไฟล์ `public.pem`) จาก SSO admin | ต่ำ–กลาง | ตกลง process รับ-เปลี่ยน key กับทีม SSO ล่วงหน้า (ใครแจ้งใคร เมื่อ SSO rotate key) — พิจารณารองรับ 2 public key พร้อมกันชั่วคราวตอน rotate กันบริการสะดุด |
| 8.15 | **(ใหม่ 22 ก.ค. 2026 — ปรับ 27 ก.ค. 2026)** ตาราง PM ตาม template (2 ระดับ + แถวสรุป, 18 คอลัมน์) + ตารางเปรียบเทียบ Entry เป็นข้อมูลหนาแน่นที่สุดในระบบ — ทำ responsive แบบ CSS ธรรมดาแล้วจะใช้งานจริงบนมือถือไม่ได้ (อ่านตัวเลขไม่ออก, กดผิดแถว) | กลาง–สูง | ต้องออกแบบ pattern การแสดงผลใหม่เฉพาะจุด (card/accordion) ก่อน ไม่ใช่แค่ทำ mobile-responsive ปกติ — แนะนำทำ mockup + ทดสอบกับ Sales/หัวหน้าจริงก่อน implement เต็มรูปแบบ (ดู 4.4/9b.11) |
| 8.16 | **(ใหม่ — ปรับ 30 ก.ค. 2026)** LINE Messaging API push มีโควตาฟรีต่อเดือนตามแพ็กเกจ OA เกินแล้วมีค่าใช้จ่ายเพิ่มหรือถูกจำกัด — ถ้า push ทุก event อาจชนโควตาเร็วกว่าคาด (**Telegram Bot API ไม่มีโควตารายเดือนแบบนี้ มีแต่ rate limit ต่อวินาที จึงเบากว่าในแง่นี้ — เป็นเหตุผลเชิงต้นทุนข้อหนึ่งที่ควรชั่งเวลาเลือกช่องทางหลัก**) | กลาง | เลือกเฉพาะ event ที่สำคัญพอต้อง push จริง (ดู 9b.15) ไม่ mirror ทุก event ในกระดิ่งไปที่ LINE ทั้งหมด — ต้องยืนยันแพ็กเกจ/โควตา LINE OA ที่จะใช้กับผู้ใช้ก่อน |
| 8.17 | **(ใหม่)** ต้องมีขั้นตอนผูกบัญชี LINE ↔ ผู้ใช้ในระบบ ไม่ใช่อัตโนมัติ 100% — ถ้า user ไม่ผูกบัญชี จะไม่ได้รับแจ้งเตือนผ่าน LINE แบบเงียบๆ (กระดิ่งในแอปยังทำงาน แต่ถ้า user ไม่ค่อยเข้าเว็บอาจพลาดงานอนุมัติ) | กลาง | UI ต้องเตือนชัดเจนตอนยังไม่ผูกบัญชี (เช่น banner "ยังไม่ได้รับแจ้งเตือนผ่าน LINE") ไม่ใช่แค่เงียบไป |
| 8.18 | **(ใหม่ — ปรับ 30 ก.ค. 2026)** ข้อความ push อาจมีข้อมูลธุรกิจ (ชื่อโครงการ/หน่วยงาน/ราคา) หลุดไปอยู่ในแอปนอกระบบ (**LINE chat และ Telegram chat**) ที่ควบคุมไม่ได้เท่าเว็บของเราเอง | กลาง | จำกัดเนื้อหาในข้อความให้น้อยที่สุดเท่าที่ยัง usable (เช่น ใส่แค่ project code + ประเภทคำขอ ไม่ใส่ราคา/GP) แล้วให้ปุ่ม deep-link เปิดรายละเอียดเต็มในเว็บที่มี auth คุมอยู่แล้วแทน — **กติกาเดียวกันทั้ง 2 ช่องทาง บังคับที่ชั้น adapter ไม่ใช่เขียนซ้ำต่อช่องทาง** |
| 8.19 | **(ใหม่ 30 ก.ค. 2026)** Telegram ต้องมีขา inbound (รับ `/start` เพื่อผูกบัญชี) ต่างจาก LINE ที่สมมติว่า push ทางเดียวพอ — เท่ากับต้องเปิด webhook ให้ Telegram เรียกเข้ามา (หรือทำ long-polling ค้างไว้) ซึ่งเป็น attack surface และงาน infra ที่แผนเดิมไม่มี | กลาง | ถ้าเลือก webhook: จำกัด path ให้เดายาก + ตรวจ `X-Telegram-Bot-Api-Secret-Token` ทุก request + รับเฉพาะ `/start` ที่มี token ที่ระบบออกให้และหมดอายุได้ (ห้ามผูกบัญชีจาก chat_id ที่ส่งมาเปล่าๆ); ถ้าเลือก long-polling: ไม่ต้องเปิด inbound port แต่ต้องมี worker ค้างตลอด — เลือกตาม hosting ที่ได้ (9b.9/9b.24) |
| 8.20 | **(ใหม่ 30 ก.ค. 2026)** มี 2 ช่องทาง push ที่รูปแบบข้อความคนละชุด (Flex Message JSON vs HTML/MarkdownV2 + inline keyboard) — ถ้าเขียน logic ตรงๆ ต่อช่องทาง เนื้อหาจะเริ่มไม่ตรงกันเมื่อแก้ทีหลัง และกติกา 8.18 จะหลุดที่ช่องทางหนึ่งโดยไม่มีใครเห็น | กลาง | แยกเป็น **channel adapter**: business logic ส่ง event + payload กลางชุดเดียว, adapter แต่ละตัวรับผิดชอบการ render — เพิ่มช่องทางที่ 3 ในอนาคตไม่ต้องแตะ business logic; test เนื้อหาที่ระดับ payload กลาง ไม่ใช่ที่ข้อความสำเร็จรูป |

---

## 9. ข้อสรุปคำถามคงค้าง (✅ ปิดครบทั้ง 24 ข้อ — ชุดเดิม 16 + updated-flow 5 ข้อ ปิด 18 ก.ค. 2026 + รอบ review 3 ข้อ ปิด 19 ก.ค. 2026)

> ตารางด้านล่างนี้คือ**ประวัติการตัดสินใจ ไม่ได้แก้ไขย้อนหลัง** — อ้างชื่อตาราง/คอลัมน์ชุดเดิม (SQL Server) ตามบริบทตอนตัดสินใจ ดูผลกระทบจาก tech stack pivot ต่อรายการเหล่านี้ได้ที่หัวข้อ 9a ถัดไป

| # | คำถาม | ข้อสรุป | ผลกระทบต่อการออกแบบ |
|---|---|---|---|
| 9.1 | Reject คำขออัพเดตสถานะ (won/lost/postpone/edit) สถานะไปไหน | ~~`rejected` ตาม Prototype~~ → **ทับด้วยรอบ review R1 (19 ก.ค. 2026): Entry กลับ `presented` — `rejected` เป็นสถานะของ**ตัวคำขอ** (RequestStatus) ไม่ใช่ Entry** | แยก EntryStatus / RequestStatus (ดู 1.4, A.8); EntryStatus `rejected` เหลือเฉพาะ Reject Register ตั้งต้น; การ์ด "โดน Reject" ใน To do list นับจากคำขอ + mitigation 8.2 (แสดงที่มาของการ reject ให้ชัด) |
| 9.2 | "แก้ไขข้อมูล Register" เมื่ออนุมัติแล้ว | **สร้างเป็น revise version ใหม่** — ของเก่ากลับไปดูแบบ read-only ได้ | เพิ่ม `RevisionNo`, `IsCurrentRevision` ใน `TTDProjectEntry` (ตารางลูก Products/Tasks ผูกกับ revision), UI เพิ่มตัวเลือกดู revision ย้อนหลัง, ประวัติ revision ในหน้า See Detail |
| 9.3 | Master ทีม | **สร้างใหม่** + ทำ **matrix user↔team mapping เป็น config** | ตารางใหม่ `project.TMTeam`, `project.TMTeamUser` + หน้าจอ config (admin) |
| 9.4 | ยี่ห้อคู่แข่ง / ประเภทหน่วยงาน | **ทำเป็น config** (admin จัดการได้) | ตารางใหม่ `project.TMCompetitorBrand`, `project.TMOrgType` + หน้าจอ config |
| 9.5 | ไฟล์แนบ | User ตั้งชื่อไฟล์ตอนอัปโหลดได้ แต่ระบบ **rename ตอนจัดเก็บเป็น `{เลขโครงการ}_{TIMESTAMP}`** เช่น `PRJ-2026-07-0001_20260718143512.pdf` | เก็บชื่อไฟล์เดิมไว้ใน `AttachFileName` เพื่อแสดงผล, path จริงใช้ชื่อ rename แล้ว — ยังใช้โฟลเดอร์ `wwwroot/Upload/{entryId}/` ตาม pattern เดิม |
| 9.6 | เกณฑ์แจ้งเตือน <90 วัน | **ทำหน้า config** (เกณฑ์วันปรับได้) + **รองรับ webhook** | ตาราง `project.TMNotificationConfig` + หน้าจอ config + งานยิง webhook (ใช้โฟลเดอร์ `BackgroundServices` ที่มีอยู่แล้วใน API repo) |
| 9.7 | หัวหน้าเห็น/อนุมัติงานใครบ้าง | **Matrix 1-M** — หัวหน้า 1 คนผูกได้หลายทีม มองเห็นได้เฉพาะทีมที่ config ไว้ | ใช้ `TMTeamUser` (แยกบทบาท member / head ใน mapping) — query หน้าอนุมัติกรองตาม matrix ไม่ใช่เห็นทุกทีม |
| 9.8 | เชื่อมกับ "โครงการ" ของ Quotation | **แยกขาดกัน** | ไม่ต้องทำ integration ใดๆ กับ `AddProject/SearchProject` เดิม |
| 9.9 | To do list รวมเมนูกลางไหม | **แยก** — โมดูลนี้เป็นเมนูใหม่ มี submenu ของตัวเอง | โครงเมนูตามหัวข้อ 4.2 ไม่แตะเมนู To Do List กลาง |
| 9.10 | นิยามการ์ด "อนุมัติแล้ว" | **ยืนยันตาม Prototype** (Register + Management ครบ และสถานะ presented) | ใช้ flag `RegisterComplete`/`ManagementComplete` ตาม A.5 |
| 9.11 | รูปแบบเลขรัน | **`PRJ-YYYY-MM-XXXX`** เช่น `PRJ-2026-07-0001` — running **reset รายเดือน** | `TMRunning` เก็บ `RunningYear` + `RunningMonth` + `CurrentNo`; `ProjectCode` ยาวขึ้น (16 ตัวอักษร) |
| 9.12 | ปิดโครงการ (closed) | ~~**ยังไม่ทำ**~~ → **เปลี่ยนตาม updated-flow 18 ก.ค. 2026: ใช้งานจริงแล้ว** — เป็นปลายทางของ "ไม่ได้งาน → ล่ม" (ปิดทันที ไม่ผ่านอนุมัติ) | Transition เดียวที่ไปถึง: `presented` --ล่ม--> `closed` (ดู 1.4 + ความเสี่ยง 8.9) — ยังไม่มีปุ่ม "ปิดโครงการ" แบบ standalone ที่อื่น |

### คำถามย่อย (✅ ปิดครบ — 18 ก.ค. 2026)

| # | คำถาม | ข้อสรุป | ผลกระทบต่อการออกแบบ |
|---|---|---|---|
| 9.13 | Workflow การสร้าง revision (ต่อจาก 9.2) | **Sales แก้ใน revision ใหม่เอง** — หัวหน้าอนุมัติคำขอ → ระบบ clone revision ใหม่ → Sales เข้าไปแก้ข้อมูลจริง | Revision ใหม่เกิดเป็นร่าง (`draft`) ให้ Sales เจ้าของ Entry แก้เฉพาะหัวข้อที่ขอไว้; คำถามที่เคยค้าง (มีผลทันทีหรืออนุมัติซ้ำ) → ✅ **ปิดแล้วด้วยข้อ 9.23: ต้องส่งอนุมัติซ้ำก่อนมีผล** (ดู 1.4, A.5b) |
| 9.14 | ชนิด/ขนาดไฟล์แนบ | **เอกสาร/PDF** (pdf, doc/docx, xls/xlsx) — **ขนาดรวมต่อ Entry ไม่เกิน 10 MB** | "ขนาดรวม" = แนบได้หลายไฟล์ → เปลี่ยน design จากคอลัมน์เดี่ยวเป็น**ตารางลูก `project.TTDProjectEntryFile`** (ดู A.5) + validate ชนิด/ขนาดรวมทั้งฝั่ง UI และ server |
| 9.15 | Webhook: ปลายทาง/payload/ความถี่ | **Pending ไว้ก่อน** | รอบนี้ทำเฉพาะแจ้งเตือน in-app (กระดิ่ง) + หน้า config เกณฑ์วัน; โครง `TMNotificationConfig` คงช่อง `WebhookUrl/WebhookEnable` ไว้เผื่ออนาคต แต่**ยังไม่ implement การยิงจริง** — ตัด background service webhook ออกจาก scope รอบนี้ |
| 9.16 | Matrix ทีม: หัวหน้าหลายคน/Sales ย้ายทีม | **งานผูกกับตัว Sales** — ย้ายทีมแล้วงานตามไปขึ้นกับหัวหน้าใหม่ได้เลย | สิทธิ์มองเห็น/อนุมัติต้อง resolve **แบบ real-time** จาก mapping ปัจจุบัน (`SaleUserName` → ทีมปัจจุบัน → หัวหน้าปัจจุบัน) ไม่ freeze ตามทีม ณ วันยื่น; `TeamID` บน Entry เก็บเป็น snapshot ไว้แสดงประวัติ/รายงานเท่านั้น ห้ามใช้คุมสิทธิ์; โครงสร้าง matrix รองรับหัวหน้าหลายคนต่อทีมอยู่แล้ว |

### คำถามจาก updated-flow (✅ ปิดครบ 5 ข้อ — 18 ก.ค. 2026)

| # | คำถาม | ข้อสรุป (คำตอบ user) | ผลกระทบต่อการออกแบบ |
|---|---|---|---|
| 9.17 | Register ตั้งต้นต้องผ่านพี่บี (Manager) อนุมัติด้วยหรือไม่ (PDF ว่าใช่ / HTML ชั้นเดียว) | **"เอาตาม html"** — หัวหน้าอนุมัติชั้นเดียว `waiting → presented` | ไม่เพิ่มสถานะ `waitingManager`; ชั้น Manager มีเฉพาะ `waitingSupervisorWon/Lost`; state machine ตาม 1.4 |
| 9.18 | Entry ที่ไม่ถูกเลือกเป็น Leader สถานะเป็นอะไร | **"Leader มีเพียง 1 Entry ต่อ Project — ผู้ถูกเลือกแค่ใส่ flag ส่วน Entry อื่นๆ ไม่ต้อง flag"** | ไม่มีสถานะ "ยกเลิก"; การจัดเก็บ (ปรับตาม review R4): **`TTHProject.LeaderEntryID` คอลัมน์เดียวเป็น source of truth** ชี้ Entry ID ที่คงที่ (flag ใน UI คำนวณจากค่านี้ — ตัดคอลัมน์ `IsLeader` ออก); Entry อื่นคงสถานะ/สิทธิ์เดิมทุกอย่าง และยังแสดงใน compare ตามปกติ; เลือกใหม่ = ย้ายค่า |
| 9.19 | รูปแบบ/การใช้งาน SYS No. | **"SYS No. เป็นเลขอีกระบบ ยังไม่ทำ"** | ตัด SysNo ออกจาก scope ทั้งหมด — คงเลขรันตัวเดียว `ProjectCode PRJ-YYYY-MM-XXXX` ออกตอนบันทึกสร้าง (ตาม 9.11) → กติกา rename ไฟล์ (9.5) ใช้ ProjectCode ได้ตามเดิม ไม่มีช่วงไม่มีเลข |
| 9.20 | Role ของ Manager ในระบบ | **"สร้างใหม่"** | เพิ่มแถวใหม่ใน `TMRole` (เสนอชื่อ `salemanager`) แนวเดียวกับ `headsale` — ไม่ reuse `manager`/`md` เดิม |
| 9.21 | สถานะ `won` ยังต้องแจ้งเตือนใกล้ครบกำหนดไหม | **"ไม่ต้อง"** | แจ้งเตือนยกเว้นทุกสถานะปลายทาง: `won`, `lost`, `closed` — นับเฉพาะงานที่ยัง active |

### คำถามจากรอบ review (✅ ปิดครบ 3 ข้อ — 19 ก.ค. 2026)

| # | คำถาม | ข้อสรุป (คำตอบ user) | ผลกระทบต่อการออกแบบ |
|---|---|---|---|
| 9.22 | lifecycle (won/lost/closed) อยู่ระดับ Project หรือ Entry (review R2) | **เพิ่ม Project-level lifecycle** | `TTHProject.ProjectStatus` (`open/won/lost/closed`) เป็นค่า derived + กติกา aggregate ตามหัวข้อ 1.5; หน้า list/แจ้งเตือนยังยึดข้อมูลราย Entry ตาม Prototype; Project จบแล้วหยุดแจ้งเตือน + ปิดรับคำขอใหม่ของ Entry ที่เหลือ; scenario D26 |
| 9.23 | ข้อมูลที่ Sales แก้บน revision ใหม่ มีผลทันทีหรือส่งอนุมัติซ้ำ (review R3) | **ต้องส่งอนุมัติซ้ำก่อนมีผล** | Flow 2 รอบ: อนุมัติคำขอ → clone revision ร่าง → Sales แก้ → ส่ง `waitingEdit` รอบ 2 → หัวหน้าอนุมัติ revision จึงเป็น current (ตัวเดิม superseded) — ใช้สถานะ Entry ชุดเดิม ไม่เพิ่มสถานะใหม่ (ดู 1.4, A.5b, D17) |
| 9.24 | D22 แจ้งเตือนหัวหน้า/Manager ตอนปิดแบบ "ล่ม" ทำอย่างไร (review R5) | **เพิ่ม event notification** | ตาราง `project.TTNotification` (event + read state, 1 แถวต่อผู้รับ) + endpoint 14 (รวม event ในกระดิ่ง) / 14d (mark อ่านแล้ว) — โครงรองรับ event อื่นในอนาคต (อนุมัติ/Reject); effort +2–3 man-day |

---

## 9a. ผลของ Tech Stack Pivot ต่อข้อสรุปในหัวข้อ 9 (เพิ่ม 21 ก.ค. 2026)

ข้อสรุปทั้ง 24 ข้อในหัวข้อ 9 (และ 0/0b) **เป็น business decision ที่ยังใช้ได้ทั้งหมด** — ส่วนใหญ่แค่เปลี่ยนชื่อตาราง/คอลัมน์ตามตารางเทียบในหัวข้อ 0c ไม่มีผลต่อเนื้อหา ยกเว้นรายการต่อไปนี้ที่ **สถานะเปลี่ยนจริง**:

| อ้างอิงข้อเดิม | สถานะใหม่ | รายละเอียด |
|---|---|---|
| 9.8 (ไม่เชื่อมกับ Quotation module เดิม) | **Moot (ไม่มีทางเกิดขึ้นได้อีกแล้ว)** | เดิมเป็นความเสี่ยงต้องระวังไม่ให้ชนกับโมดูลอื่นในโค้ด/DB เดียวกัน — ตอนนี้ standalone แยกขาดสมบูรณ์ จึงไม่มีทางไปชนกันได้อีก ไม่ต้องระวังอะไรเพิ่ม |
| 9.9 (To do list กลางของระบบเดิม) | **Moot** | ไม่มี "เมนู To Do List กลาง" ของระบบเดิมให้เลือกรวมหรือแยกอีกแล้ว — ระบบใหม่มี To-do list ของตัวเองเท่านั้น |
| 9.20 (Role ของ Manager — สร้างใหม่ใน `TMRole`) | **Reopened แล้วปิดใหม่** | ประเด็น "ไม่ reuse role เดิม" หมดไปเอง (moot เพราะ standalone) — คำถามที่เปิดใหม่ (role/permission เก็บที่ local table หรือมาจาก SSO claim ตรงๆ) **ปิดแล้ว 21 ก.ค. 2026: มาจาก JWT `roles` claim ตรงๆ ไม่มีตาราง local** — ดู 9b.3/9c |
| 9.6 (webhook — เสนอใช้โฟลเดอร์ `BackgroundServices` ของ API repo เดิม) | **เปลี่ยนกลไก** | ของใหม่เสนอ `node-cron` หรือ queue/worker แยก (ดูหัวข้อ 5) — ข้อสรุปเรื่อง "ทำ config ได้ + webhook ยังไม่ implement จริง" ไม่เปลี่ยน |
| 9.5 (rename ไฟล์แนบ — เดิมอ้างโฟลเดอร์ `wwwroot/Upload/{entryId}/` แบบ IIS) | **เปลี่ยน implementation detail** | path/storage backend เป็นคำถามใหม่ (9b.5) — กติกา "rename เป็น `{ProjectCode}_{TIMESTAMP}_{Seq}`" ยังใช้ได้เหมือนเดิมไม่ว่าจะเก็บที่ไหน |
| 9.3 / 9.4 / 9.7 / 9.16 (Master ทีม, ยี่ห้อคู่แข่ง, ประเภทหน่วยงาน, matrix สิทธิ์) | **ไม่เปลี่ยนเนื้อหา** | แค่ชื่อตารางเปลี่ยนตาม 0c (`TMTeam`→`project.team` ฯลฯ) |
| อื่นๆ ที่ไม่อยู่ในตารางนี้ (9.1, 9.2, 9.9–9.15 ที่เหลือ, 9.17–9.19, 9.21–9.24) | **ไม่เปลี่ยน** | ยังใช้ข้อสรุปเดิมได้ตรงๆ นอกจากชื่อตาราง/คอลัมน์ที่เทียบได้จาก 0c |

---

## 9b. คำถามคงค้างใหม่จาก Tech Stack Pivot (เปิด 21 ก.ค. 2026 — 9b.1–9b.3 ปิดแล้ว 21 ก.ค. 2026 ดู 9c, ที่เหลือยังเปิดอยู่)

| # | คำถาม | สมมติฐานที่ใช้เขียนเอกสารนี้ไปก่อน | Blocking อะไรถ้ายังไม่ปิด |
|---|---|---|---|
| 9b.1 | SSO provider/protocol (OIDC vs SAML, IdP ตัวไหน) | ✅ **ปิดแล้ว 21 ก.ค. 2026 — ดู 9c**: "SSO Management" ภายในองค์กร, OAuth2 Authorization Code Flow, JWT RS256 | ~~ปิด spec ส่วน auth ทั้งหมดไม่ได้~~ → ปิดแล้ว (หัวข้อ 4.3, 5, ภาคผนวก A.13, B intro/B.2 ปรับตาม 9c ครบ) |
| 9b.2 | Session/token strategy หลัง SSO ยืนยันตัวตนแล้ว (server session cookie / JWT access token / BFF pattern) | 🟡 **ปิดเกือบหมด 21 ก.ค. 2026 — ดู 9c**: กลไกฝั่ง SSO ปิดแล้ว (token exchange ต้องทำฝั่ง server, access token 15 นาที, refresh token 7 วันใช้ครั้งเดียว) — เหลือ **1 ทางเลือกภายในทีมเอง** (ไม่ใช่คำถามของ SSO): BFF cookie (แนะนำ) vs ส่ง token ให้ React ถือตรงๆ | ไม่ blocking แล้ว — เลือกทางไหนก็ implement auth middleware/React auth layer ได้ตาม 4.3/5 |
| 9b.3 | Role/permission เก็บที่ local table (`auth.role`) หรือมาจาก SSO claim ตรงๆ | ✅ **ปิดแล้ว 21 ก.ค. 2026 — ดู 9c**: มาจาก JWT `roles` claim ตรงๆ (array, app-specific ผ่าน `group_role_map` เฉพาะ client_id นี้) — ไม่มีตาราง role local, มีแค่ `auth.user` (provisioning cache ไม่ใช่ authority) | ~~กระทบ schema/Access Matrix~~ → ปิดแล้ว (A.13, B.2 ปรับตามนี้) — งานที่เหลือคือ **ประสานกับ SSO admin ให้ตั้งค่า group_role_map ให้ครบ 4 role ตอนลงทะเบียนแอป** |
| 9b.4 | ORM/query layer สำหรับ Postgres (Prisma / Drizzle / Knex+pg / อื่นๆ) | ยกตัวอย่างไว้ทั้ง 3 แบบในหัวข้อ 5 — ไม่ฟันธง | กระทบรูปแบบ migration script (ภาคผนวก A.14) และโครงสร้างโค้ด service layer |
| 9b.5 | ที่เก็บไฟล์แนบ (local disk ของ API server vs object storage เช่น S3-compatible) | แนะนำ object storage ในความเสี่ยง 8.5 — ไม่ใช่การตัดสินใจ | กระทบ schema `entry_file.file_path` (path string vs object key), กระทบ endpoint 24 (ภาคผนวก B) |
| 9b.6 | Repo topology (mono-repo เดียว vs แยก UI/API เป็น 2 repo) + ชื่อ repo/โปรเจกต์ | ยังไม่ตั้งชื่อ — เอกสารนี้เขียนเป็น "UI" / "API" เฉยๆ | ไม่กระทบ business spec แต่กระทบ CI/CD และการตั้งค่า deploy |
| 9b.7 | Design system/component library ฝั่ง React (MUI/Ant Design/Chakra/Tailwind ฯลฯ) | ไม่ฟันธง — ระบุตัวเลือกไว้ในหัวข้อ 4.1 | กระทบเวลาออกแบบ UI (เพิ่มงานเทียบกับแผนเดิมที่มี theme สำเร็จรูป — ดูหัวข้อ 10) |
| 9b.8 | แหล่งข้อมูลภูมิศาสตร์ไทย (จังหวัด/อำเภอ/ตำบล/ไปรษณีย์) ใหม่ | สมมติว่าต้อง seed จาก dataset เปิดสาธารณะเอง (ความเสี่ยง 8.13) | กระทบ `project.dealer` และฟอร์ม Register ส่วนที่อยู่ Dealer |
| 9b.9 | Hosting/deployment target + CI/CD | ยังไม่ระบุ | ไม่กระทบ business spec แต่ต้องรู้ก่อนวางแผน timeline จริง |
| 9b.10 | มีข้อมูลใดจากระบบ Syndome CRM เดิมที่ต้อง migrate/import เข้าระบบใหม่ครั้งเดียวหรือไม่ (เช่น รายชื่อ user/Dealer ที่มีอยู่แล้ว) หรือเริ่มจาก DB ว่างเปล่าทั้งหมด | **สมมติว่าเริ่มว่างเปล่า ไม่ migrate อะไรจากเดิมเลย** ตาม "ไม่อิงกับอันเดิมใดใดเลย" | ถ้าจริงๆ ต้อง migrate ข้อมูลบางส่วน (เช่น Dealer ที่ Sales กรอกไว้แล้วในระบบเดิม) จะเพิ่มงานใหม่ทั้งก้อนที่เอกสารนี้ยังไม่ได้ประเมิน |
| 9b.11 | **(ใหม่ 22 ก.ค. 2026 — ดู 0d.1/0d.2)** Responsive breakpoint + pattern การแสดงผลตารางข้อมูลหนาแน่น (ตาราง PM ตาม template — 18 คอลัมน์ 2 ระดับ, ตารางเปรียบเทียบ Entry) บนจอมือถือ | สมมติ card/accordion pattern แทนตารางกว้าง — **ยังไม่ออกแบบละเอียด ยังไม่มี mockup** | กระทบเวลาออกแบบ UI หน้า PM/compare มากที่สุดในทั้งระบบ (ดูความเสี่ยง 8.15) |
| 9b.12 | **(ใหม่ — ดู 0d.3)** ใช้ LINE Official Account ตัวไหน — OA ที่องค์กรมีอยู่แล้ว (เช่นของบริษัทแม่/CRM เดิม) หรือสร้างใหม่เฉพาะระบบนี้ | ยังไม่ระบุ | กระทบ Channel ID/Secret ที่ต้องขอ, กระทบว่าโควตาข้อความใช้ร่วมกับระบบอื่นในองค์กรหรือไม่ (ดูความเสี่ยง 8.16) |
| 9b.13 | **(ใหม่)** วิธีผูกบัญชี LINE ↔ ผู้ใช้ในระบบ — LINE Login OAuth เต็มรูปแบบ vs ให้ user ยืนยันรหัสผ่านแชทกับ OA vs admin กรอก LINE userId เอง | ยังไม่ระบุ — LINE Login เป็นแนวทางมาตรฐานสุด (คล้าย OAuth flow ของ SSO ที่มีอยู่แล้ว จึง reuse pattern ความคุ้นเคยได้) | กระทบ endpoint account-linking ใหม่ (ดูหัวข้อ 5), กระทบว่าต้องขอ LINE Login channel เพิ่มจาก LINE Developers หรือไม่ |
| 9b.14 | **(ใหม่)** แจ้งเตือน LINE เป็น one-way push อย่างเดียว หรือต้องกดอนุมัติ/ไม่อนุมัติได้จากปุ่มใน Flex Message โดยตรง (ต้องมี webhook รับ postback) | สมมติ **push อย่างเดียว + ปุ่ม deep-link เปิดเว็บ** ไปก่อน (ไม่ต้องมี webhook, ทำเร็วกว่า) | ถ้าต้องการอนุมัติจากใน LINE จริง ต้องเพิ่ม webhook endpoint ใหม่ + คิดกลไกยืนยันตัวตนจาก LINE เอง (คนละกลไกกับ SSO) — งานเพิ่มมาก ไม่ใช่แค่ต่อยอด |
| 9b.15 | **(ใหม่)** เหตุการณ์ไหนบ้างที่ต้อง push LINE — เฉพาะ "รออนุมัติ" หรือรวม approved/rejected/won/lost/ล่ม ด้วย | สมมติ **เฉพาะเหตุการณ์ที่ต้องการ action จากผู้รับ** (รออนุมัติ, ล่ม-แจ้งหัวหน้า/Manager) ก่อน ไม่ push ทุก state change | กระทบปริมาณ push (ผูกกับความเสี่ยง 8.16 เรื่องโควตา) และ design ของ Flex Message แต่ละแบบที่ต้องทำ |
| 9b.22 | **(ใหม่ 27 ก.ค. 2026 — ดู 0f.3)** ช่อง `รายการ`/`Model` ในตาราง Project Management **ดึงจาก item master ของ ERP** — ยังไม่สรุปว่าเชื่อมอย่างไร: ERP ตัวไหน / มี REST API ให้เรียกไหม (ค้นหา + ดึงราคาทุนล่าสุด) / หรือ sync เป็นรอบเข้ามาเก็บใน `project` DB / หรือรอบแรกให้พิมพ์เองไปก่อน | สมมติ **รอบแรกกรอกเองได้เหมือน template + เตรียมคอลัมน์ `erp_item_code` ไว้** ยังไม่ต่อ ERP จริง (ผู้ใช้ระบุว่า "ค้างไว้ก่อน") | กระทบ: (1) ตัวเลข man-day ของตาราง PM ในหัวข้อ 10 (ถ้าต้องต่อ API + จัดการ cache/ราคาที่เปลี่ยน) (2) กติกาว่าต้นทุนที่กรอกต้องผูกกับราคา ERP ณ วันไหน (`cost_quote_date` ใน A.8.2) (3) ถ้า ERP เป็นแหล่งราคาทุน อาจกระทบเรื่องสิทธิ์เห็นต้นทุน (ความเสี่ยง 8.1) |
| 9b.23 | **(ใหม่ 30 ก.ค. 2026 — ดู 0g)** ใช้ Telegram bot ตัวไหน — สร้าง bot ใหม่เฉพาะระบบนี้ (ผ่าน BotFather) หรือมี bot ขององค์กรอยู่แล้ว + **องค์กรอนุญาตให้ใช้ Telegram เป็นช่องทางงานได้จริงหรือไม่** (บางองค์กรบล็อก) | สมมติสร้าง bot ใหม่เฉพาะระบบนี้ | กระทบ bot token ที่ต้องขอ/เก็บเป็น secret, กระทบว่าต้องคุยกับ IT เรื่อง policy ก่อนไหม |
| 9b.24 | **(ใหม่ 30 ก.ค. 2026)** วิธีผูกบัญชี Telegram + จะรับ `/start` ด้วย **webhook** (ต้องเปิด inbound HTTPS ให้ Telegram เรียก) หรือ **long-polling** (worker ค้าง ไม่ต้องเปิด port) | สมมติ deep-link `https://t.me/<bot>?start=<token>` โดยระบบออก token ผูกกับ user + หมดอายุ แล้วรับผ่าน webhook | กระทบ infra/hosting (9b.9) และความเสี่ยง 8.19 — **ต่างจาก LINE ที่ push ทางเดียวไม่ต้องมี inbound เลย** |
| 9b.25 | **(ใหม่ 30 ก.ค. 2026)** ผู้ใช้ 1 คนต้องเลือกช่องทางเดียว หรือรับได้ทั้ง LINE และ Telegram พร้อมกัน (และใครเป็นคนตั้ง — user เองหรือ admin) | สมมติผูกได้ทั้ง 2 ช่องทาง และส่งทุกช่องทางที่ผูกไว้ (`push_channel_pref` ไว้เผื่อให้ user จำกัดเอง) | กระทบ 6.4 (คอลัมน์บน `auth.user`), ปริมาณข้อความที่ส่งจริง (ผูก 2 ช่อง = 2 ข้อความต่อ event) และความเสี่ยง 8.16 |

---

## 9c. ปิดคำถาม SSO จากหัวข้อ 9b (เพิ่ม 21 ก.ค. 2026 — อ้างอิงเอกสาร "SSO Management — App Integration Guide" ที่ผู้ใช้ให้มา)

ผู้ใช้ส่งเอกสารสเปกของระบบ SSO กลางที่มีอยู่แล้วในองค์กร ("SSO Management") มาให้ — เป็น Authentication Gateway ที่ยืนยันตัวตนผ่าน Active Directory (LDAP bind), ออก JWT (RS256) ให้แอป downstream ใช้ ปิดคำถาม 9b.1–9b.3 ได้เกือบทั้งหมดตามนี้:

**Flow ที่จะใช้:** OAuth2 Authorization Code Flow (ตามเอกสาร SSO ข้อ 2.1) — เพราะระบบนี้เป็น "แอปทั่วไป" ไม่ใช่ internal portal/admin ที่ SSO แนะนำให้ใช้ Standalone Login (ข้อ 2.2) ตรงๆ ได้

**ผังการทำงานโดยสรุป:**

1. React แสดงปุ่ม "เข้าสู่ระบบ" เป็นลิงก์ไป endpoint login ของ Fastify เอง (ข้างในต่อไป `GET {SSO_BASE_URL}/v1/oauth2/auth?client_id=...&redirect_uri=...&scope=openid+profile+email&state=...`) — คุม `state` ฝั่ง server ไม่ generate ที่ browser
2. User เห็นหน้า login ของ SSO เอง (ไม่ต้องสร้างหน้า login ในระบบนี้)
3. SSO redirect กลับมาที่ callback endpoint ของ Fastify (`GET /auth/callback?code=...&state=...`)
4. Fastify (server-side เท่านั้น — ต้องใช้ `client_secret` ห้ามอยู่ browser) เรียก `POST /v1/oauth2/token` (`application/x-www-form-urlencoded` — **ไม่ใช่ JSON**) แลก `code` เป็น `access_token`/`refresh_token`
5. Fastify verify + เก็บ token คู่นี้ไว้ฝั่ง server แล้วออก **session cookie ของเราเอง** (httpOnly) ให้ React ถือแทน — ดู "สิ่งที่ยังเหลือ" ด้านล่าง

**สิ่งที่ปิดแล้ว** (ตาราง 9b ด้านบนอัปเดตสถานะแล้ว):

| ประเด็น | คำตอบ |
|---|---|
| Provider/Protocol (9b.1) | SSO Management ภายในองค์กร, OAuth2 Authorization Code Flow, JWT RS256 (issuer `sso-management`) |
| Token lifetime | Access token 15 นาที (900s) / Refresh token 7 วัน (604800s, **ใช้ได้ครั้งเดียว** — rotate ทุกครั้งที่ refresh, อันเก่าถูก revoke ทันที) |
| Verify JWT | **Local** ฝั่งเรา ด้วย public key (RS256) — ไม่ต้อง callback กลับไปหา SSO ทุก request — ตรวจ `exp`/`iss`/`aud` แล้วอ่าน `sub`/`name`/`email`/`roles` |
| Role/permission (9b.3) | มาจาก JWT `roles` claim ตรงๆ (array, app-specific — SSO admin ตั้งค่า `group_role_map` เฉพาะ client_id ของระบบนี้ให้ map AD group → role string) — **ไม่ต้องมีตาราง role local** (ตัด option (b) ของ A.13 เดิม) |
| Auto-provisioning | เอกสาร SSO แนะนำ: ครั้งแรกที่ verify token สำเร็จ ให้ upsert user record ในระบบเราเอง — เพิ่มตารางใหม่ `auth.user` (ดู A.13) |

**สิ่งที่ยังเหลือให้ทีมตัดสินใจเอง** (ไม่ใช่คำถามของ SSO อีกต่อไป — 9b.2 ปิดเกือบหมด เหลือแค่นี้): React (browser) ควรถือ SSO token เองหรือไม่ — 2 ทางเลือก

- **(แนะนำ) BFF pattern**: Fastify เก็บ SSO access/refresh token ไว้ฝั่ง server เท่านั้น ออก session cookie ของตัวเอง (httpOnly, ผูกกับ session ฝั่ง server) ให้ React ถือแทน — React ไม่เห็น token ของ SSO เลย ลด XSS attack surface และไม่ต้อง implement refresh-rotation logic ฝั่ง client เอง (Fastify จัดการ refresh เบื้องหลังได้)
- (ทางเลือก) ส่ง `access_token` ให้ React เก็บ (memory/storage) แล้วแนบ `Authorization: Bearer` เองไปทุก request หา Fastify — ง่ายกว่าตอน implement แต่ token อายุ 15 นาทีหมดบ่อย ต้อง implement refresh logic ฝั่ง client เพิ่ม และเสี่ยง XSS สูงกว่า (token อยู่ browser)

เอกสารนี้เขียนหัวข้อ 4.3/5 ตามแนวทาง BFF (แนะนำ) ไปก่อน — ทีมยืนยันเปลี่ยนได้ทีหลังโดยไม่กระทบ schema/business logic ส่วนอื่น (กระทบแค่ชั้น auth เท่านั้น)

**Gotcha ที่ต้องระวังตอน implement** (จากเอกสาร SSO โดยตรง):

- `/token`, `/refresh`, `/logout` รับ `application/x-www-form-urlencoded` **ไม่ใช่** `application/json` — ผิดชนิดนี้จุดเดียวจะ error ทั้งชุด
- Authorization code อายุแค่ 5 นาที — ต้องแลกเป็น token ทันทีหลัง callback
- `roles` ใน JWT payload เป็น **array** (`string[]`) แต่ `roles` ที่ได้จาก `GET /v1/oauth2/userinfo` เป็น **string ตัวเดียว** (role แรกเท่านั้น) — ใช้ `/userinfo` เพื่อ auto-provisioning/แสดงผลได้ แต่ **ตัดสินสิทธิ์ต้องอ่านจาก JWT payload เท่านั้น**
- ไม่มี JWKS endpoint — ต้องขอไฟล์ `public.pem` จาก SSO admin แบบ manual และมีกระบวนการรับ key ใหม่ตอน rotate (ดูความเสี่ยงใหม่ 8.14)
- ถ้า Active Directory/LDAP ล่ม → login ไม่ได้เลยทั้งองค์กร ไม่มี local fallback (ดูความเสี่ยงปรับปรุง 8.11)

**งานที่ต้องประสานกับทีม SSO** (ไม่ใช่งานเขียนโค้ดของระบบนี้):

1. ลงทะเบียนแอปเพื่อขอ `client_id`/`client_secret`
2. แจ้ง `redirect_uri` (callback URL จริงของ Fastify เมื่อ deploy แล้ว — กระทบ 9b.9)
3. ขอให้ตั้งค่า `group_role_map` ให้ AD group ที่เกี่ยวข้อง map เป็น role string `sales`/`headsale`/`salemanager`/`admin` ให้ครบ
4. ขอไฟล์ public key (`public.pem`) สำหรับ verify JWT + ช่องทางแจ้งเตือนล่วงหน้าเมื่อมีการ rotate key

---

## 10. ประเมินขนาดงาน (คร่าวๆ — **รวม Manager/พี่บีแล้ว** ตาม updated-flow — ปรับผ่านรอบ 5–11 แล้ว)

> ℹ️ **สถานะตัวเลข (ปรับ 30 ก.ค. 2026):** ยอดรวมท้ายตาราง (**~79–119 man-day**) เป็นตัวเลข**หลัง**ปรับตามรอบ 5 (re-platform), 6 (Auth/SSO), 7 (Mobile+LINE), 8 และ 11 (เพิ่มแล้วตัด AI Chat + เพิ่ม Telegram) แล้ว — ดูประวัติการปรับใต้ตาราง **ไม่ใช่ตัวเลขค้างจากยุค .NET** ส่วนตัวเลขราย**บรรทัด**บางแถวยังเป็นสัดส่วนที่ประเมินไว้ตั้งแต่ stack เดิม — **ลำดับความซับซ้อนสัมพัทธ์ระหว่างงานแต่ละก้อนยังอ้างอิงได้** (เพราะความซับซ้อนมาจาก business logic เป็นหลัก ไม่ใช่จากภาษา/framework) แต่ยังมี 3 ตัวแปรที่ทำให้ยอดรวมขยับได้อีก: (1) รู้ว่าทีมคุ้นเคย React/Node/Postgres แค่ไหน (ความเสี่ยง 8.12 — ยังไม่ทราบ), (2) ✅ ปิดคำถาม SSO แล้ว (ดู 9c) — Auth/SSO estimate รวมอยู่ในตารางด้านล่างแล้ว, (3) เลือก ORM/design system แล้ว (9b.4/9b.7 — ยังไม่เลือก) — เพิ่มเวลาส่วน "ออกแบบ design system ใหม่ทั้งชุด" (ข้อ 4.2.4) ที่รอบเดิมไม่มี เพราะรอบเดิมมี theme สำเร็จรูปให้แปลงอยู่แล้ว

| งาน | ประมาณการ (man-day) |
|---|---|
| เขียน spec/API contract (คำถาม business ปิดครบ 24 ข้อแล้ว, SSO ปิดแล้ว — เหลือคำถาม stack 9b ที่ blocking 2 ข้อ: ORM 9b.4 / design system 9b.7 — ข้ออื่นเช่น repo topology 9b.6 ไม่ blocking) | 3–4 |
| DB design + migration script + seed master (+ ตาราง/คอลัมน์ใหม่จาก updated-flow) | 3–4 |
| API: entities/service/endpoints + validation state machine **2 ชั้นอนุมัติ (won/lost) + แพ้/ล่ม** | 10–14 |
| API: revision versioning (แยกตาราง Entry/Revision + flow อนุมัติซ้ำรอบ 2 — ข้อ 9.23/review R4) | 3–5 |
| API+UI: Project-level lifecycle (aggregate `ProjectStatus` + badge + กติกาหยุดรับคำขอ — ✅ ข้อ 9.22) | 1–2 |
| API+UI: event notification (`notification` table + read state + รวมในกระดิ่ง — ✅ ข้อ 9.24) | 2–3 |
| UI: หน้า list ทั้ง 3 + sort/filter bar + ฟอร์ม Register + ตรวจซ้ำ + Dealer modal | 6–9 |
| UI+API: ตาราง Project Management **ตาม Template Excel** (2 ระดับ + แถวสรุป, roll-up ทุกคอลัมน์, สูตร GP หัก EP + กติกา OC, master EP item type) — ⚠️ **ตัวเลขเดิมประเมินจากตารางแบบ prototype ที่ทุกแถวอิสระ ต้องทบทวนใหม่หลังปิด 9b.22 (ERP item)** | 3–4 (รอทบทวน) |
| UI: หน้าเปรียบเทียบ Entry + ประวัติเหตุผล 2 role + ดู revision ย้อนหลัง | 3–5 |
| UI: โซนอัพเดตสถานะ 4 ฟอร์ม + draft + **ทางแยก แพ้/ล่ม** | 4–5 |
| UI: ฝั่งหัวหน้า (Approve Zone, รายการรออนุมัติ, Approval Detail + กรองตาม matrix ทีม) | 4–6 |
| UI: ฝั่ง Manager — หน้าอนุมัติชั้น Supervisor + หน้า "ระบุ Leader Project" (list + detail เทียบ Entry) | 4–6 |
| หน้าจอ config: matrix ทีม-user, ยี่ห้อคู่แข่ง, ประเภทหน่วยงาน, เหตุผลแพ้/สาเหตุล่ม, เกณฑ์แจ้งเตือน (ข้อ 9.3/9.4/9.6) | 3–5 |
| แจ้งเตือน in-app **กรองตาม role (Sale/หัวหน้า/Manager — ข้อ 0.6)** + เมนู + role ×2 + กลไกเปิด/ปิดเมนู (ออกแบบใหม่ ไม่มีของเดิมให้ reuse) (ยิง webhook จริง **pending** — ข้อ 9.15) | 2–3 |
| **(ใหม่) ออกแบบ design system/component library ตั้งแต่ต้น** (ไม่มี theme สำเร็จรูปให้แปลงเหมือนรอบเดิม — ดู 4.1/9b.7) | 2–4 |
| **Auth/SSO integration (API+UI)** — ปิดแล้ว ดู 9c: OAuth2 client แบบ BFF (callback/token exchange/refresh/logout ฝั่ง Fastify + JWT verify middleware + auto-provisioning `auth.user`) + protected route/login redirect ฝั่ง React | 6–9 |
| **(ใหม่ 22 ก.ค. 2026 — ดู 0d/4.4) Responsive ทุกหน้า + ออกแบบใหม่เฉพาะจุด** (mockup + build pattern การ์ด/accordion สำหรับตาราง PM/compare บนมือถือ — งานออกแบบยาก ไม่ใช่แค่ CSS) | 5–8 |
| **(ใหม่ — ดู 0d/5/6.4) LINE Messaging integration** (account-linking flow + Flex Message template ต่อ event type + dispatch service แบบ async ผ่าน channel adapter) | 4–6 |
| **(ใหม่ 30 ก.ค. 2026 — ดู 0g) Telegram Bot integration** (adapter ตัวที่ 2 + template HTML/inline keyboard + account-linking ที่ต้องรับ `/start` ผ่าน webhook หรือ long-polling — ถูกกว่า LINE เพราะ dispatch service/ตาราง/UI ผูกบัญชีใช้ร่วมกันแล้ว) | 2–3 |
| ทดสอบรวม + แก้บั๊ก + UAT (เพิ่ม flow Manager + แพ้/ล่ม + auth ผ่าน SSO — D29 + responsive/LINE + Telegram — D30–D31) | 9–13 |
| **รวม (รวม Auth/SSO + Mobile + LINE + Telegram — ✂️ ไม่รวม AI Chat Assistant ที่ตัดออกแล้ว, ไม่รวม ramp-up stack ใหม่)** | **~79–119 man-day** |

> ตัวเลขเป็น effort รวม UI+API ถ้าทำขนาน 2 คน (UI/API) ระยะเวลาปฏิทินประมาณ **12–16 สัปดาห์รวม UAT** (รวม Auth/SSO + Mobile + LINE/Telegram — ✂️ ตัด AI Chat ออกแล้วตาม 0g — ยังไม่รวม ramp-up stack ใหม่ถ้ามี) — ประวัติการปรับตัวเลขรอบก่อนหน้า: รอบ 2 เพราะ updated-flow ดึงขั้น Manager/พี่บีเข้ามาทั้งหมด (~43–65 → ~54–78 man-day); รอบ 3/4 (review) เพิ่ม Project-level lifecycle, revision อนุมัติซ้ำ, event notification (~54–78 → ~59–86 man-day); รอบ 5 (re-platform) เพิ่มงาน design system ใหม่ แต่ตัด/ปรับงานที่เคย workaround เฉพาะ .NET ออก (เช่น file upload ผ่าน MVC action) — สุทธิใกล้เคียงเดิม (~59–86 → ~61–90 man-day) บวก Auth/SSO ที่ตอนนั้นยัง estimate ไม่ได้; รอบ 6 (ปิด SSO): เพิ่ม Auth/SSO integration 6–9 man-day เข้ารวมยอด (~61–90 → ~67–99 man-day); รอบ 7 (Mobile + LINE): เพิ่ม Responsive 5–8 + LINE integration 4–6 man-day เข้ารวมยอด (~67–99 → ~76–113 man-day) — ตัวเลข Mobile/LINE นี้ยังหยาบกว่าส่วนอื่นเพราะคำถาม 9b.11–9b.15 ยังไม่ปิดเลยสักข้อ; **รอบ 8 (AI Chat Assistant):** เพิ่ม Chat orchestration 8–12 + Conversation storage/aggregate 3–4 + Chat UI 4–6 + Security/policy 3–5 man-day เข้ารวมยอด (~76–113 → ~95–143 man-day) — ก้อนงานใหญ่ที่สุดในบรรดา 3 รอบขยายขอบเขตหลังปิด business spec (0d/0e) เพราะเป็น subsystem ใหม่ทั้งชุด (LLM orchestration + conversation UI) ไม่ใช่แค่ integration จุดเดียวแบบ LINE — และมีคำถาม blocking (9b.16 — LLM data policy) ที่ต้องปิดก่อนเริ่ม ไม่ต่างจาก SSO เดิมที่เคย block ทั้งชุด — ยังไม่รวม ramp-up stack ใหม่ถ้าทีมไม่คุ้นเคย React/Node/Postgres (ความเสี่ยง 8.12 ยังไม่ทราบคำตอบ); **รอบ 11 (30 ก.ค. 2026): ตัด AI Chat Assistant ออกทั้งก้อน −18–27 man-day (Chat orchestration 8–12 + Conversation storage/aggregate 3–4 + Chat UI 4–6 + Security/policy 3–5) และเพิ่ม Telegram เป็นช่องทาง push ที่ 2 +2–3 man-day → สุทธิ ~95–143 → ~79–119 man-day**

### ลำดับงานแนะนำ

0. **ปิดคำถาม 9b ที่ยัง blocking** — ตอนนี้เหลือหลักๆ คือ ORM (9b.4) และ design system (9b.7) — **SSO (9b.1–9b.3) ปิดแล้ว (ดู 9c) ไม่ block อีกต่อไป** และ **คำถาม blocking เรื่อง LLM provider/data policy หมดไปพร้อมการตัดขอบเขต chat (ดู 0e/0g)**
1. เขียน spec (คำถาม business ปิดครบแล้ว — แนะนำใช้ openspec workflow ที่มีอยู่ใน repo)
2. DB migration + API contract (mock ได้)
3. ทำ flow หลักก่อน: Create Register + PM → ส่งอนุมัติ → หัวหน้าอนุมัติ/Reject → presented
4. ตามด้วยตรวจซ้ำ + Entry + **ระบุ Leader (Manager)**, อัพเดตสถานะ 4 แบบ (รวมแยก แพ้/ล่ม), **อนุมัติชั้น Manager → won/lost**, หน้าเปรียบเทียบ, แจ้งเตือนตาม role
5. เสียบชั้น auth/SSO ได้ตั้งแต่ตอนไหนก็ได้ (รายละเอียดครบแล้วตาม 9c) — จะทำคู่ขนานกับงานอื่นหรือรวบไว้ท้ายสุดก็ได้ ไม่ใช่ dependency ที่ต้องรออีกต่อไป
6. **Responsive + LINE/Telegram (ดู 0d/0g) แนะนำทำหลังสุด** — ทำ desktop flow หลักให้ใช้งานได้ครบก่อน ค่อยทำ mobile layout เฉพาะจุด (โดยเฉพาะ PM/compare ที่ต้องออกแบบใหม่) แล้วค่อยต่อ LINE/Telegram เข้ากับ event notification ที่มีอยู่แล้ว (ทำ adapter กลางก่อน แล้วเสียบช่องทางแรก จะได้ไม่ต้องรื้อตอนเสียบช่องที่ 2) — ปิดคำถาม 9b.11–9b.15 + 9b.23–9b.25 ก่อนเริ่มจริงจัง (ยังไม่ปิดข้อไหนเลย ต่างจาก SSO ที่ปิดแล้วก่อนเริ่ม 5)

---

## ภาคผนวก A — ร่างโครงสร้างตาราง (PostgreSQL DDL Draft)

> **หมายเหตุการตั้งชื่อ:** schema `project`, ตาราง/คอลัมน์ทั้งหมดใช้ `snake_case` (ดูตารางเทียบชื่อเดิม↔ใหม่ในหัวข้อ 0c) — ทุกตารางมี PK `id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY` + audit `created_at TIMESTAMPTZ NOT NULL DEFAULT now(), created_by TEXT, updated_at TIMESTAMPTZ, updated_by TEXT` / ตัวเงินใช้ `NUMERIC(18,2)` / ข้อความใช้ `TEXT` เป็นค่าเริ่มต้น (ยกเว้นมีรูปแบบตายตัวจริงถึงจะจำกัดด้วย `VARCHAR(n)`)

### A.1 `project.status` — master สถานะ (13 แถว)

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id | BIGINT GENERATED ALWAYS AS IDENTITY PK | |
| code | TEXT | `draft`, `waiting`, `rejected`, `presented`, `waitingPostpone`, `waitingEdit`, `waitingWon`, `waitingLost`, `waitingSupervisorWon`, `waitingSupervisorLost`, `won`, `lost`, `closed` — แนะนำเพิ่ม `CHECK (code IN (...))` กันค่าหลุดโดยไม่ต้องพึ่ง native enum (แก้ list ทีหลังง่ายกว่า Postgres ENUM) |
| name | TEXT | ชื่อไทย เช่น "รอหัวหน้าอนุมัติได้งาน" |
| description | TEXT | |
| seq_no | INT | ลำดับแสดงผล |
| badge_style | TEXT | class สี badge ฝั่ง UI |
| is_active | BOOLEAN | |

### A.2 `project.dealer` — master Dealer

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id | BIGINT GENERATED ALWAYS AS IDENTITY PK | |
| name | TEXT | btree index + `pg_trgm` GIN index สำหรับ fuzzy search |
| address | TEXT | |
| province_id / amphur_id / tambon_id / postal_code | BIGINT / BIGINT / BIGINT / TEXT | **ต้อง seed ข้อมูลภูมิศาสตร์ไทยเอง** (เดิม reuse lookup API ของระบบเดิมได้ฟรี — ตอนนี้ standalone แล้วไม่มีให้ reuse, ดูความเสี่ยง 8.13/9b.8) |
| is_temporary | BOOLEAN | Dealer ชั่วคราวที่ Sales เพิ่มเอง |
| is_active | BOOLEAN | |

### A.3 `project.running_number` — เลขรัน (`PRJ-YYYY-MM-XXXX` reset รายเดือน)

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id | BIGINT GENERATED ALWAYS AS IDENTITY PK | |
| prefix | TEXT | `PRJ` |
| running_year | INT | |
| running_month | INT | 1–12 — คู่ (year, month) ละ 1 แถว |
| current_no | INT | อัพเดตใน transaction ด้วย `SELECT ... FOR UPDATE` กันเลขชนกัน (เทียบเท่า `UPDLOCK` เดิมของ SQL Server) |

### A.4 `project.registration` — หัวโครงการ (1 แถว = 1 Project)

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id | BIGINT GENERATED ALWAYS AS IDENTITY PK | |
| project_code | VARCHAR(20) | `PRJ-2026-07-0001` — UNIQUE |
| org_name | TEXT | |
| org_name_norm | TEXT | `GENERATED ALWAYS AS (lower(regexp_replace(trim(org_name), '\s+', ' ', 'g'))) STORED` + index — ใช้ตรวจซ้ำ |
| project_name / project_name_norm | TEXT | เช่นเดียวกัน |
| org_type_id | BIGINT FK → `project.org_type` | |
| project_status | TEXT | Project-level lifecycle `open/won/lost/closed` เป็นค่า derived (default `open`) — คำนวณใหม่ทุกครั้งที่ Entry เข้าสถานะปลายทาง + log ลง `project.status_log` |
| leader_entry_id | BIGINT FK → `project.entry`, NULL | Entry ที่ Manager เลือกเป็น Leader (NULL = ยังไม่ระบุ) + `leader_assign_by`/`leader_assign_date` — source of truth เดียวของ Leader |
| is_active | BOOLEAN | |

> **Project identity = `org_name_norm` + `project_name_norm` เท่านั้น (✅ 0f.4, 27 ก.ค. 2026)** — ไม่มีคอลัมน์ normalized ของ Dealer ที่ระดับ Project และ**ไม่ต้องมี** เพราะ Dealer เป็นข้อมูลระดับ Entry (`entry_revision.dealer_id`) โดยเจตนา: ขาย B2B — Dealer หลายเจ้าเข้ามาขอราคางานเดียวกันได้ ซึ่งคือเหตุผลที่ Project หนึ่งมีหลาย Entry ตั้งแต่แรก → แนะนำ UNIQUE index บน `(org_name_norm, project_name_norm)` เมื่อ `is_active` เพื่อกัน Project ซ้ำระดับ DB ไม่ใช่พึ่งการตรวจฝั่ง UI อย่างเดียว

### A.4b `project.registration_revision` — revision ระดับ Project (**ใหม่ 27 ก.ค. 2026 — ✅ 0f.6**)

เหตุผล: ฟอร์ม "แก้ไขข้อมูล" ให้เลือกแก้ **ชื่อหน่วยงาน / ชื่อโครงการ** ได้ ซึ่งเป็นข้อมูลบน `project.registration` ที่ **ทุก Entry ของ Project ใช้ร่วมกัน และเป็น key ตรวจซ้ำ** — เก็บเป็น revision ของ Entry ไม่ได้ จึงต้องมีชั้น revision ของตัวเองคู่ขนานกับ `entry_revision`

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id | BIGINT GENERATED ALWAYS AS IDENTITY PK | |
| project_id | BIGINT FK → `project.registration` | |
| revision_no | INT | เริ่ม 1 — **UNIQUE (project_id, revision_no)** |
| revision_status | TEXT | `draft` / `waiting` / `current` / `superseded` — ชุดเดียวกับ `entry_revision` |
| is_current_revision | BOOLEAN | **unique partial index** `(project_id) WHERE is_current_revision` |
| org_name / project_name / org_type_id | TEXT / TEXT / BIGINT | ค่าที่ถูกแก้ในรอบ revision นั้น |
| ref_request_id | BIGINT FK → `project.status_request`, NULL | คำขอ `edit` ที่เป็นต้นเรื่อง |
| requested_by_entry_id | BIGINT FK → `project.entry` | Entry (และ Sales) ที่เป็นคนขอแก้ — ใช้หาว่าหัวหน้าคนไหนเป็นผู้อนุมัติ |
| is_active | BOOLEAN | |

**กติกาที่ต้อง implement คู่กัน:**

1. คำขอ `edit` ที่หัวข้อเป็น **ชื่อหน่วยงาน / ชื่อโครงการ / ประเภทหน่วยงาน** → อนุมัติแล้วเปิด **`registration_revision` ร่าง**; หัวข้ออื่น (Dealer / เงื่อนไขการขาย / ข้อมูลสินค้า / ระยะเวลารับประกัน) → เปิด **`entry_revision` ร่าง** ตามเดิม (9.23)
2. ค่าใหม่มีผลกับ **ทุก Entry ของ Project** — UI ต้องเตือนผู้ขอให้ชัดว่าการแก้นี้กระทบ Entry ของ Sales คนอื่นด้วย (ไม่ใช่แก้เฉพาะของตัวเอง)
3. ตอนอนุมัติ revision ระดับ Project ต้อง **ตรวจซ้ำอีกครั้งด้วย key ใหม่ (org+project)** — ถ้าชนกับ Project อื่นที่มีอยู่ ให้ปฏิเสธพร้อมชี้ Project ที่ชน (กัน Project ซ้ำเกิดจากทางแก้ไขข้อมูล)
4. คอลัมน์ `org_name_norm`/`project_name_norm` บน `project.registration` อัพเดตตามค่าที่ approve แล้วเท่านั้น (revision ร่างยังไม่แตะ)
5. log ลง `project.status_log` แบบระบุ `project_id` (แถวระดับ Project ตาม A.11)

### A.5 `project.entry` — identity ของ Entry (1 แถว = 1 Entry ตลอดชีวิต)

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id | BIGINT GENERATED ALWAYS AS IDENTITY PK | identity คงที่ — `leader_entry_id` และ FK อื่นอ้างค่านี้ได้เสมอไม่ว่าจะ revise กี่รอบ |
| project_id | BIGINT FK → `project.registration` | |
| entry_sequence | INT | 1 = เจ้าของ Project — **UNIQUE (project_id, entry_sequence)** |
| entry_code | TEXT | `PRJ-2026-07-0001-E2` — UNIQUE |
| sale_user_name | TEXT | เจ้าของ Entry — คุมสิทธิ์เขียนตาม B.2 (ต้อง match กับ identity ที่ verify จาก SSO ตอนเขียน) |
| status_id | BIGINT FK → `project.status` | สถานะ workflow อยู่ระดับ Entry |
| register_complete / management_complete | BOOLEAN | ใช้คิดการ์ด "อนุมัติแล้ว" ใน To do list |
| is_active | BOOLEAN | |

### A.6 `project.entry_revision` — ข้อมูลฟอร์มราย revision

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id | BIGINT GENERATED ALWAYS AS IDENTITY PK | |
| entry_id | BIGINT FK → `project.entry` | |
| revision_no | INT | เริ่ม 1 — **UNIQUE (entry_id, revision_no)** |
| revision_status | TEXT | `draft` / `waiting` / `current` / `superseded` |
| is_current_revision | BOOLEAN | **unique partial index** `(entry_id) WHERE is_current_revision` — invariant: current ต่อ Entry มีแถวเดียวเสมอ (สั้นกว่า filtered index ของ SQL Server เพราะ boolean ใช้ตรงๆ ได้) — สลับ current ใน transaction เดียว |
| team_id | BIGINT FK → `project.team` | snapshot ณ วันยื่น — ห้ามใช้คุมสิทธิ์ (ข้อ 9.16) |
| dealer_id | BIGINT FK → `project.dealer` | |
| dealer_snapshot | TEXT | ชื่อ+ที่อยู่ Dealer ณ วันที่ยื่น |
| sale_condition | TEXT | เงื่อนไขการขาย |
| expect_finish_date | DATE | วันคาดจบ |
| warranty_lifetime | BOOLEAN | ตลอดอายุการใช้งาน |
| warranty_years | NUMERIC(4,1) | |
| warranty_start_date / warranty_end_date | DATE | |
| is_active | BOOLEAN | |

> ตารางลูกทั้งสามผูกกับ `revision_id` (ไม่ใช่ `entry_id`) — `entry_file` / `entry_product` / `entry_task` ถูก clone ตอนสร้าง revision ใหม่

**`project.entry_file`** — `id, revision_id FK, seq_no, file_path TEXT (หรือ object storage key — ดูความเสี่ยง 8.5/9b.5), file_name TEXT (ชื่อเดิมที่ user ตั้ง), file_size_kb INT, file_type TEXT, is_active, audit`

- ชนิดที่รับ: เอกสาร/PDF (pdf, doc/docx, xls/xlsx) — validate ทั้ง client และ server
- ขนาดรวมทุกไฟล์ต่อ revision ≤ 10 MB (server ตรวจผลรวมก่อนรับไฟล์ใหม่)
- rename ไฟล์เป็น `{project_code}_{TIMESTAMP}_{Seq}.{ext}` กันชื่อชน (หลักการเดิมไม่เปลี่ยน)

### A.7 `project.entry_product` — สินค้าใน revision

`id, revision_id FK, seq_no, model TEXT, product_group TEXT (Commercial/Innovative/Premium/Superior/Heavy Duty/Enterprise), batt_type TEXT, qty_batt INT, batt_bank INT, option TEXT, qty NUMERIC(12,2), unit_price NUMERIC(18,2), amount NUMERIC(18,2), is_active, audit`

### A.8 `project.entry_task` — ตาราง Project Management (**ยึด `prototype/Template_ProjectManagement.xlsx` sheet `หลายรายการ` — ปรับ 27 ก.ค. 2026 ดู 0f**)

> **source of truth ของตารางนี้คือ Template Excel ที่ผู้ใช้กรอกงานจริง ไม่ใช่ตาราง PM ใน `Role_Sale_Lastest.html`** — คอลัมน์ / กลุ่มคอลัมน์ / ระดับ record / สูตรคำนวณ ยึดตาม template ทั้งหมด จุดที่ต่างจาก prototype อยู่ท้ายหัวข้อนี้

#### A.8.1 โครงสร้าง record 3 ชั้น: แถวสรุป → main item → spec line (ตาม template)

| ระดับ | ที่มาใน template | เก็บใน DB | ความหมาย |
|---|---|---|---|
| **แถวสรุปโครงการ** | R3–R4 (`ปี ?? : ชื่องาน/ชื่อโครงการ : ? Ys`, `ชื่อเซลล์`, `ชื่อ Dealer`) | ❌ **ไม่เก็บ** — คำนวณตอนแสดงผล | ยอดรวมทั้ง Entry = ตัวเลขชุดเดียวกับการ์ดหน้าเปรียบเทียบ (ปิดคำถาม A2 เดิม); หัวแถวดึงจาก Register (ชื่อหน่วยงาน/ชื่อโครงการ/Sales/Dealer/จำนวนปีประกัน) ไม่กรอกซ้ำ |
| **Main item** (`task_level = 1`) | R5, R9 — `ลำดับ` 1, 2 + `รายการ/สเปก` | ✅ | 1 แถว = 1 รายการที่เสนอขาย — ทุกช่องตัวเลข roll-up จาก spec line ไม่ให้กรอกมือ (ยกเว้น `qty`) |
| **Spec line** (`task_level = 2`) | R6–R8, R10–R12 | ✅ | บรรทัดสเปก/BOM ของ main item (ตัวเครื่อง / แบต / SNMP / ค่าขนส่ง / OC) — **ระดับเดียวที่กรอกตัวเลขจริง** |

**สีพื้นในไฟล์ = ชั้นของการ group (ยืนยันจาก fill + Excel outline level ในไฟล์จริง):**

| สีพื้น | outline level | คือแถวอะไร | ที่มาของตัวเลข |
|---|---|---|---|
| **ขาว** (ไม่มีสีพื้น) | 2 | Spec line — R6–R8, R10–R12 | กรอกมือ |
| **เทาอ่อน** (theme 0 tint −0.25) | 1 | Main item — R5, R9 | **รวมขึ้นมาจากแถวสีขาวในกลุ่มของตัวเอง** |
| **เทาเข้ม** (theme 0 tint −0.35) | 0 | แถวสรุปโครงการ — R4 (และ R3 ที่ mirror ค่าจาก R4 ขึ้นมาโชว์ที่หัวตาราง) | **รวมขึ้นมาจากแถวเทาอ่อนทุกกลุ่ม** |
| **เหลือง** (`FFFF00`) | — | เน้นเฉพาะช่อง ไม่ใช่ทั้งแถว: ต้นทุน `@` (F), EP `Amt.` (J), ราคาขาย `@` (K), GP `Amt.` (N) | ช่องกรอกมือหลัก + ช่องผลลัพธ์ที่ต้องดู |

> UI ควรสื่อลำดับชั้นนี้ให้ตรงกับที่ผู้ใช้ชินจาก Excel (สีพื้น/การยุบ-ขยายกลุ่มแบบ outline) ไม่ใช่แค่ย่อหน้าเข้าไปเฉยๆ

#### A.8.2 คอลัมน์ (เรียงตาม template A–R)

| Col | หัวตาราง (กลุ่ม / ชื่อ) | คอลัมน์ DB | หมายเหตุ |
|---|---|---|---|
| A | ลำดับ | `seq_no INT` | main = 1, 2, 3…; spec line เรียงในกลุ่มพ่อ (แสดงผลเป็น 1.1/1.2 ได้ ไม่เก็บเป็นข้อความ) |
| B | รายการ | `item_name TEXT` | main = ชื่อรายการ/สเปก; spec = ชื่อรุ่น/สเปก (comment ใน template: *"ใส่ Revision Name"* สำหรับแถวตัวเครื่อง, *"ขนาดแบต @ จำนวน x ราคา"* สำหรับแถวแบต) — **ค่านี้จะดึงจาก ERP (item master) ดู 9b.22** |
| C | Sale (แถวสรุป) / **Brand** (spec) | `brand TEXT` | template ใช้คอลัมน์เดียวร่วมกัน 2 ความหมาย — ฝั่ง DB **ไม่ overload**: ชื่อ Sale มาจาก `entry.sale_user_name` อยู่แล้ว, เก็บเฉพาะ `brand` ที่ spec line; แถว main แสดง `COUNT(DISTINCT brand)` ของลูก (template ใช้ `COUNTA`) — ค่าคำนวณ ไม่เก็บ |
| D | Dealer (แถวสรุป) / **Model** (spec) | `model TEXT` | เช่นเดียวกัน — Dealer มาจาก `entry_revision.dealer_id` อยู่แล้ว; แถว main แสดง `COUNT(DISTINCT model)` ของลูก |
| E | Q'ty | `qty NUMERIC(12,2)` | template ใช้จำนวนเต็ม (`#,##0`) — spec line กรอกเอง, main = กรอกเอง หรือ = qty ของ spec line แรก (template ใช้ทั้ง 2 แบบ: `E5=300` ตรงๆ, `E9==E10`) → **ระบบยึดแบบ auto: main = Qty ของ spec line แรก (ไม่ใช่ผลบวกของลูก) และแถวสรุป = Σ Qty ของ main ทุกแถว — ดู A.8.3.2** |
| F–G | **ต้นทุน** @ / Amt. | `cost_unit`, `cost_amt NUMERIC(18,2)` | + `cost_quote_date DATE NULL` — comment ใน template: *"ให้ใส่เสนอว่าราคา ณ วันที่เท่าไร"* (ราคาทุนต้องระบุว่าเป็นราคา ณ วันไหน) |
| H–J | **EP** รายการ / @ / Amt. | `ep_item TEXT`, `ep_unit`, `ep_amt NUMERIC(18,2)` | EP = ค่าใช้จ่ายเพิ่มนอกต้นทุนสินค้า (ตัวอย่างจริงใน template: `ค่าขนส่ง`, `OC`) — **`OC` = Overriding Commission (ฝั่ง Dealer ใช้คำว่า Outside Commission) = ค่าคอมมิชชั่นที่จ่ายให้ Dealer / คนหา lead ฝั่ง Dealer — เป็น "รายการหนึ่งในกลุ่ม EP" ไม่ใช่คอลัมน์แยก** และเป็นตัวที่ทำให้ GP มี 2 ชุด (A.8.3) + `ep_type_id BIGINT FK → project.ep_item_type` (มี flag `is_oc`) + `ep_quote_date DATE NULL`, `ep_source TEXT NULL` — comment ใน template: *"ราคาต้องได้จากจัดส่งเท่านั้น เมื่อได้ราคามาแล้ว ให้เอามาใส่ พร้อมลงวันที่ที่ได้ราคามา"* |
| K–L | **ราคาขาย** @ / Amt. | `sell_unit`, `sell_amt NUMERIC(18,2)` | ใน template ราคาขายกรอกที่ spec line แรกของ main item (เป็นราคาต่อหน่วยของทั้งรายการ) ไม่ได้กรอกทุกบรรทัด |
| M–O | **GP** @ / Amt. / % | `gp_unit`, `gp_amt NUMERIC(18,2)`, `gp_pct NUMERIC(9,2)` | **ค่า derived ทั้งหมด ห้ามให้กรอกมือ** (ต่างจาก prototype ที่เป็น input) — สูตรดู A.8.3 |
| P–R | **Bid Result → ราคาขายคู่แข่ง** รุ่น / @ / Amt. | `bid_competitor_model TEXT`, `bid_competitor_unit`, `bid_competitor_amt NUMERIC(18,2)` | 3 คอลัมน์ตาม template |
| — | โครงสร้าง | `id, revision_id FK, parent_task_id (self-FK, NULL = main), task_level SMALLINT (1–2), erp_item_code TEXT NULL, is_active` + audit | `erp_item_code` เตรียมไว้ผูกกับ item master ของ ERP (ดู 9b.22 — ยังไม่ต่อจริงรอบนี้) |

#### A.8.3 สูตรคำนวณ — **server เป็น source of truth ทุกระดับ** (React คำนวณได้แค่ preview)

**Spec line (`task_level = 2`)** — ระดับที่กรอกจริง:

- `cost_amt = cost_unit × qty` (template `G6 = F6*E6`)
- `sell_amt = sell_unit × qty` (template `L6 = E6*K6`)
- `ep_unit = ep_amt ÷ qty(main)` (template `I6 = J6/E5` — หารด้วย Qty ของ **main item** ไม่ใช่ของแถวตัวเอง)
- `gp_amt = sell_amt − cost_amt(main) − ep_amt(main เฉพาะรายการที่ is_oc = false)` = **GP ก่อนหัก OC** (template `N6 = L6-G5-J5`, `N10 = L10-G9-J10`)
- `gp_unit = gp_amt ÷ qty(main)` , `gp_pct = gp_amt ÷ sell_amt × 100`

**Main item (`task_level = 1`)** — roll-up จากลูกทั้งหมด:

- `qty` = กรอกที่ main; `cost_unit = Σ spec.cost_unit`, `cost_amt = Σ spec.cost_amt` (template `F5 = SUM(F6:F8)`, `G5 = SUM(G6:G8)`)
- `ep_unit = Σ spec.ep_unit`, `ep_amt = Σ spec.ep_amt` (**รวมทุกรายการ EP รวมทั้งรายการ OC**), `sell_unit = Σ spec.sell_unit`, `sell_amt = Σ spec.sell_amt`
- `gp_amt = sell_amt − cost_amt − ep_amt(ทุกรายการ)` = **GP หลังหัก OC** (template `N5 = L5-G5-J5`, `N9 = L9-J9-G9`)
- `gp_unit = gp_amt ÷ qty` , `gp_pct = gp_amt ÷ sell_amt × 100`

**แถวสรุปโครงการ (ไม่เก็บใน DB)** — รวมจาก **main item เท่านั้น ห้ามรวม spec line ซ้ำ**:

- `qty = Σ main.qty` , `cost_amt = Σ main.cost_amt` , `ep_amt = Σ main.ep_amt` , `sell_amt = Σ main.sell_amt` (template `E4=E5+E9` ฯลฯ)
- **ค่าต่อหน่วยที่ระดับสรุปเป็นค่าถัวเฉลี่ย ไม่ใช่ผลบวก**: `cost_unit = cost_amt ÷ qty`, `ep_unit = ep_amt ÷ qty`, `sell_unit = sell_amt ÷ qty` (template `F4 = G4/E4`)
- `gp_amt = sell_amt − cost_amt − ep_amt` , `gp_unit = gp_amt ÷ qty` , `gp_pct = gp_amt ÷ sell_amt × 100`

> 🔑 **นิยาม GP ที่ใช้ทั้งระบบ: `GP = ราคาขาย − ต้นทุน − EP` และ `GP% = GP ÷ ราคาขาย × 100`** (ปิดคำถาม A1 — template ยืนยันว่า **หัก EP ด้วย** ต่างจากสูตรใน `calcRow` ของ prototype ที่ไม่หัก EP) — ตัวเลขชุดนี้ไปโผล่ที่การ์ดหน้าเปรียบเทียบ, ป้าย "GP สูงสุด/ดีที่สุด" และรายงานสรุปทุกจุด

#### A.8.3.1 กติกา OC — GP 2 ชุด (จุดที่พลาดง่ายที่สุดในตารางนี้)

**`OC` = Overriding Commission** (ฝั่ง Dealer เรียก *Outside Commission*) = ค่าคอมมิชชั่นจ่ายให้ Dealer / คนหา lead ฝั่ง Dealer — **เป็นรายการหนึ่งในกลุ่ม EP** (คอลัมน์ H–J) ไม่ใช่คอลัมน์ของตัวเอง

หมายเหตุที่เจ้าของไฟล์เขียนไว้เองในเซลล์ M12: *"กรณีมี OC แถวช่องขาวคิด GP ไม่รวม OC / ช่องสีเทา คิดรวม OC"* — **ตัวเลขจริงในไฟล์ (main item ที่ 2 ซึ่งมีรายการ OC 150,000 อยู่ในแถว R11) เป็นดังนี้:**

| แถว | สูตรในไฟล์ | ค่า | หัก OC ออกจาก GP ไหม |
|---|---|---|---|
| **R10 สีขาว** (spec line) | `N10 = L10 − G9 − J10` → 5,100,000 − 2,226,713.70 − **10,000 (เฉพาะค่าขนส่ง)** | **2,863,286.30** (GP% 56.14) | ❌ **ไม่หัก** → GP ก่อนหัก OC |
| **R9 เทาอ่อน** (main item) | `N9 = L9 − J9 − G9` → 5,100,000 − **160,000 (ค่าขนส่ง 10,000 + OC 150,000)** − 2,226,713.70 | **2,713,286.30** (GP% 53.20) | ✅ **หัก** → GP หลังหัก OC |
| **R4 เทาเข้ม** (สรุปโครงการ) | `N4 = L4 − G4 − J4` โดย `J4 = J5 + J9 = 170,000` (รวม OC) | **5,426,572.60** | ✅ **หัก** |

ผลต่าง `N10 − N9 = 150,000` = ค่า OC พอดี → **ยืนยันว่าไฟล์ทำงานแบบ: แถวขาวไม่หัก OC (GP สูงกว่า) / แถวเทาทั้ง 2 ชั้นหัก OC (GP ต่ำกว่า)**

**สิ่งที่ระบบต้องทำ:** เก็บ/แสดง GP **2 ชุดคู่กันเสมอเมื่อ main item นั้นมีรายการ OC**

- `gp_before_oc` (แถวขาว) = `ราคาขาย − ต้นทุน − EP ที่ is_oc = false` — margin ก่อนจ่ายค่าคอม Dealer — **ถ้า main item นั้นมีรายการ OC อยู่ในกลุ่ม EP ช่อง GP ของแถวขาวจะไม่หัก OC ออก (ข้อสรุปผู้ใช้ 27 ก.ค. 2026)**
- `gp_after_oc` (แถวเทาอ่อน/เทาเข้ม) = `ราคาขาย − ต้นทุน − EP ทั้งหมด` — margin จริงหลังจ่ายค่าคอม
- main item ที่ไม่มีรายการ OC → ค่า 2 ชุดเท่ากัน ไม่ต้องแสดงแยก
- **ต้องรู้ว่า EP แถวไหนเป็น OC จาก flag ในฐานข้อมูล (`project.ep_item_type.is_oc`) ห้าม match จากข้อความใน `ep_item`** (พิมพ์ว่า "OC 5% N Success" / "Support งาน Sale 1%" ก็ยังต้องจับได้ถูก)

> ✅ **ยืนยันจากผู้ใช้แล้ว (27 ก.ค. 2026):** *"เฉพาะแถวขาว — ถ้ามี OC อยู่ในรายการ EP ช่อง GP ของแถวขาวจะไม่รวม (ไม่หัก) OC"* → ตรงกับตัวเลขที่คำนวณจริงในไฟล์ทุกประการ **ปิดประเด็นนี้แล้ว ไม่ต้องถามซ้ำ**: แถวขาว = GP ก่อนหัก OC / แถวเทาอ่อน + เทาเข้ม = GP หลังหัก OC

> ✅ **ข้อสรุป (ยืนยันแล้ว 2 ส.ค. 2026 — ปิดประเด็น ไม่ต้องถามซ้ำ):** ตัวเลข GP ที่แสดง**นอกหน้า Project Management** — การ์ด/ตารางหน้าเปรียบเทียบ Entry, ป้าย "GP สูงสุด/ดีที่สุด" และรายงานสรุปใดๆ ในอนาคต — ใช้ **`gp_after_oc`** (margin จริงหลังจ่ายค่าคอม Dealer) เป็นค่าหลัก **เสมอ** เพราะเป็นตัวเลขที่ใช้ตัดสินใจทางธุรกิจจริง ส่วน `gp_before_oc` แสดงเฉพาะในตาราง PM ที่แถวสีขาวตาม template เท่านั้น — ตรงกับ spec `project-entry-comparison` ที่เขียนเป็นข้อกำหนดบังคับ (SHALL) ไว้แล้ว

#### A.8.3.2 ช่องไหนกรอกมือ / ช่องไหน auto — **ต้องรวมยอดอัตโนมัติเหมือน Excel (ข้อสรุปผู้ใช้ 27 ก.ค. 2026)**

หลักการ: **ถ้า main item นั้นมี spec line (รายการย่อย) อยู่ ช่องตัวเลขของแถว main และแถวสรุปต้องคำนวณให้เองทั้งหมด ห้ามให้พิมพ์ทับ** — พฤติกรรมเดียวกับสูตรใน Excel ที่ผู้ใช้ใช้อยู่ (พิมพ์ที่แถวขาว → แถวเทาอ่อน → แถวเทาเข้ม อัปเดตขึ้นไปเอง)

| Col | คอลัมน์ | Spec line (ขาว) | Main item (เทาอ่อน) | แถวสรุป (เทาเข้ม) |
|---|---|---|---|---|
| A | ลำดับ | auto (ลำดับในกลุ่ม) | auto (1, 2, 3…) | — |
| B | รายการ | **กรอก** (เลือกจาก ERP item — 9b.22) | **กรอก** | จาก Register (ชื่อโครงการ) |
| C | Brand | **กรอก** | auto = `COUNT(DISTINCT brand)` ของลูก | ชื่อ Sales (จาก Register) |
| D | Model | **กรอก** | auto = `COUNT(DISTINCT model)` ของลูก | ชื่อ Dealer (จาก Register) |
| E | Q'ty | **กรอก** | auto = Qty ของ spec line แรก — **ไม่ใช่ผลบวกของลูก** (ลูกเป็นส่วนประกอบของชุดเดียวกัน ใช้ Qty ชุดเดียวกัน ตาม template `E9==E10`) | auto = **Σ Qty ของ main item ทุกแถว** (`E4=E5+E9`) |
| F | ต้นทุน @ | **กรอก** (+ `cost_quote_date`) | auto = **Σ** ของลูก | auto = `cost_amt ÷ qty` |
| G | ต้นทุน Amt. | auto = `@ × Qty` | auto = **Σ** ของลูก | auto = **Σ** ของ main |
| H | EP รายการ | **กรอก** (เลือกจาก `ep_item_type`) | auto = จำนวนรายการ EP ของลูก | — |
| I | EP @ | auto = `EP Amt ÷ Qty(main)` | auto = **Σ** ของลูก | auto = `ep_amt ÷ qty` |
| J | EP Amt. | **กรอก** (+ `ep_quote_date`/`ep_source`) | auto = **Σ** ของลูก | auto = **Σ** ของ main |
| K | ราคาขาย @ | **กรอก** | auto = **Σ** ของลูก | auto = `sell_amt ÷ qty` |
| L | ราคาขาย Amt. | auto = `@ × Qty` | auto = **Σ** ของลูก | auto = **Σ** ของ main |
| M–O | GP @ / Amt. / % | auto (ก่อนหัก OC) | auto (หลังหัก OC) | auto (หลังหัก OC) |
| P–R | ราคาขายคู่แข่ง รุ่น / @ / Amt. | **กรอก** | — | — |

**กติกาที่ต้อง implement คู่กัน:**

1. **คำนวณสดทันทีที่พิมพ์** (เหมือน Excel) — ไม่ต้องกดปุ่ม "คำนวณ" และไม่ต้องบันทึกก่อนถึงจะเห็นยอดรวม
2. **ช่อง auto ทุกช่องเป็น read-only** (แสดงต่างจากช่องกรอก เช่นพื้นสีตาม A.8.1) พิมพ์ทับไม่ได้ — โดยเฉพาะช่อง GP ทั้ง 3 ช่อง ที่ prototype เดิมเปิดให้พิมพ์เอง
3. **เพิ่ม / แก้ / ลบ spec line → recalculate ไล่ขึ้นทันที** (spec → main → แถวสรุป → การ์ดสรุปหน้าเปรียบเทียบ) ไม่ใช่รอ refresh
4. **เคส main item ที่ไม่มี spec line เลย** (งาน "รายการเดียว" ที่ไม่ต้องแตกสเปก): ช่องของแถว main กลับมากรอกมือได้ — พอเพิ่ม spec line แรกเข้ามา ระบบสลับเป็นโหมด auto และเตือนก่อนทับค่าที่กรอกไว้
5. **ฝั่ง server คำนวณซ้ำเสมอตอน `/save` และทิ้งค่า aggregate ที่ client ส่งมาทุกครั้ง** (ไม่ใช่แค่ validate) — ค่าที่เก็บลง DB คือค่าที่ server คำนวณเท่านั้น
6. เก็บค่า aggregate ของแถว main ลง DB (denormalized) เพื่อให้ list/รายงานสรุป query ได้เร็ว ส่วนแถวสรุปโครงการยังคำนวณตอนอ่าน (A.8.1)

#### A.8.4 จุดที่ต่างจากตาราง PM ใน `Role_Sale_Lastest.html` (ยึด template เป็นหลัก)

1. **ระดับ record: 2 ระดับ + แถวสรุป** (prototype รองรับ 3 ระดับ) — `parent_task_id` ยังเป็น self-FK รองรับลึกกว่านี้ได้ในอนาคต แต่ UI/validation รอบนี้ยึด 2 ระดับตาม template
2. **GP เป็นค่า derived** (prototype ให้กรอก `GP @`/`GP Amt` เอง) และ **หัก EP** (prototype ไม่หัก)
3. **แถว main เป็น roll-up ทั้งแถว** (prototype ทุกแถวอิสระต่อกัน ไม่มีการรวมยอด) + ช่อง Brand/Model ที่แถว main แสดงเป็น **จำนวนนับ** ตาม `COUNTA` ของ template
4. **ยอดรวมระดับ Entry = ผลรวมของ main item เท่านั้น** (prototype รวม Qty ทุกแถวทุกระดับ → นับซ้ำ)
5. คอลัมน์ `Sale`/`Dealer` ในตาราง PM ของ prototype **ตัดออก** — template ใช้ค่าจาก Register (แถวสรุป) ไม่ได้กรอกรายแถว
6. Bid Result เหลือ **3 คอลัมน์ตาม template** (`ราคาขายคู่แข่ง`: รุ่น/@/Amt.) — คอลัมน์ "รุ่น (ของเรา)" ที่ prototype มีเพิ่มมา ไม่มีใน template
7. เพิ่ม field ที่ template ระบุผ่าน comment แต่ prototype ไม่มี: `cost_quote_date`, `ep_quote_date`/`ep_source`
8. ช่องต้นทุน @ ใน template มีการพิมพ์เป็นนิพจน์คำนวณ (`=294.893*3` = จำนวนแบต × ราคาต่อลูก) — UI ควรรองรับพิมพ์นิพจน์คูณ/บวกในช่องเงิน หรืออย่างน้อยมีช่อง `qty × unit` ย่อยสำหรับแบต (ยังไม่ตัดสินใจ — ไม่ blocking)

### A.9 `project.status_request` — คำขออัพเดตสถานะ (won/lost/postpone/edit)

| คอลัมน์ | ชนิด | หมายเหตุ |
|---|---|---|
| id / entry_id | BIGINT | |
| request_type | TEXT | `won` / `lost` / `postpone` / `edit` |
| is_draft | BOOLEAN | รองรับ "บันทึกร่าง" ของทุกฟอร์ม |
| request_status | TEXT | `pending` / `approvedHead` (รอ Manager) / `approved` / `rejected` / `draft` — Reject ที่ชั้นใดก็ตาม → `rejected` และ Entry กลับ `presented` (review R1) |
| — Bid Result (won/lost-แพ้) | | `sale_analysis TEXT, competitor_brand TEXT, competitor_model TEXT, competitor_price NUMERIC(18,2), inspector_name TEXT, result_date DATE` |
| — Lost แยกทาง (ข้อ 0.3) | | `lost_type TEXT` (`lose`/`collapse`), `lost_reason_id FK → project.lost_reason`, `collapse_reason_id FK → project.collapse_reason`, `collapse_date DATE`, `collapse_note TEXT` — กรณี `collapse` ระบบเปลี่ยน Entry เป็น `closed` ทันที ไม่สร้างงานอนุมัติ |
| — Postpone | | `old_expect_date DATE, new_expect_date DATE, postpone_reason TEXT` |
| — Edit | | `edit_field TEXT, edit_new_value TEXT, edit_reason TEXT` |
| ผลพิจารณา | | `action_by TEXT, action_date TIMESTAMPTZ, reject_reason TEXT` (รายละเอียดรายชั้นดูใน `project.approval` — head/supervisor) |

### A.10 `project.approval` — ประวัติการพิจารณา (แสดงในหน้า See Detail ทั้ง 2 role)

`id, entry_id FK, request_id FK NULL (NULL = อนุมัติ Register+PM), approver_role TEXT (head/supervisor), approval_type TEXT, action TEXT (approve/reject), reason TEXT, action_by, action_date, audit`

### A.11 `project.status_log` — log การเปลี่ยนสถานะ

`id, project_id FK NULL (log ระดับ Project ใช้คู่ from_project_status/to_project_status TEXT NULL — review R2), entry_id FK NULL, from_status_id, to_status_id (FK project.status — NULL สำหรับแถวระดับ Project), ref_request_id NULL, remark TEXT, action_by, action_date` — รองรับ requirement "เก็บวันเดิมไว้ใน Log" ของการเลื่อนวันคาดจบ + log ระดับ Project (✅ ข้อ 9.22)

### A.12 ตาราง config

| ตาราง | คอลัมน์หลัก | หมายเหตุ |
|---|---|---|
| `project.team` | `id, name TEXT, seq_no, is_active` + audit | master ทีมขาย (seed 10 ทีมจาก Prototype เป็นค่าตั้งต้น) |
| `project.team_user` | `id, team_id FK, user_name TEXT, role_in_team TEXT ('member'/'head'), is_active` + audit | matrix 1-M — สิทธิ์มองเห็นและอนุมัติของ `headsale` กรองจากตารางนี้ (ข้อ 9.7), UNIQUE (team_id, user_name, role_in_team) |
| `project.competitor_brand` | `id, name TEXT, seq_no, is_active` + audit | ยี่ห้อคู่แข่ง — admin จัดการผ่านหน้า config |
| `project.org_type` | `id, name TEXT, seq_no, is_active` + audit | ประเภทหน่วยงาน — admin จัดการผ่านหน้า config |
| `project.ep_item_type` **(ใหม่ 27 ก.ค. 2026)** | `id, name TEXT, is_oc BOOLEAN, seq_no, is_active` + audit | ชนิดรายการ EP — seed จาก template: `ค่าขนส่ง` (`is_oc = false`), **`OC` — Overriding Commission (ฝั่ง Dealer เรียก Outside Commission) = ค่าคอมจ่าย Dealer/ผู้หา lead** (`is_oc = true`) — **`is_oc` เป็นตัวตัดสินว่ารายการนี้ถูกหักใน GP ชุด "หลังหัก OC" (A.8.3.1) ห้ามเดาจากข้อความชื่อรายการ** (ในไฟล์จริงมีการพิมพ์เป็น `OC 5% N Success`, `Support งาน Sale 1%`) |
| `project.lost_reason` | `id, name TEXT, seq_no, is_active` + audit | เหตุผลที่แพ้ — seed: ราคา, Specification, ระยะเวลาส่งมอบ, เงื่อนไขการขาย, อื่นๆ |
| `project.collapse_reason` | `id, name TEXT, seq_no, is_active` + audit | สาเหตุที่โครงการล่ม — seed: ลูกค้ายกเลิกโครงการ, งบประมาณไม่ผ่าน, โครงการเลื่อนโดยไม่มีกำหนด, ไม่มีการจัดซื้อ, อื่นๆ |
| `project.notification_config` | `id, near_due_days INT default 90, webhook_url TEXT, webhook_enable BOOLEAN, notify_enable BOOLEAN` + audit | เกณฑ์แจ้งเตือนปรับได้ + ปลายทาง webhook (ข้อ 9.6) |
| `project.notification` | `id, notify_type TEXT ('collapseClosed', ...), project_id, entry_id, ref_request_id NULL, message TEXT, target_user_name TEXT, is_read BOOLEAN default false, read_date TIMESTAMPTZ NULL` + audit | event notification: สร้าง 1 แถวต่อผู้รับตอนเกิด event — **INDEX (target_user_name, is_read)** |

### A.13 role/auth — ปิดแล้ว: เลือกตัวเลือก (a), เพิ่มตาราง `auth.user` สำหรับ provisioning

ปิดตามเอกสาร SSO Management Integration Guide (ดู 9c) — **role/permission มาจาก JWT `roles` claim ของ SSO ตรงๆ (ตัวเลือก (a) เดิม) ไม่ต้องมีตาราง `auth.role`/`auth.user_role` local** เพราะ SSO มีกลไก `group_role_map` ต่อ client_id อยู่แล้ว (แอปนี้ขอให้ SSO admin ตั้งค่าให้ AD group ที่เกี่ยวข้อง map เป็น role string `sales`/`headsale`/`salemanager`/`admin` ตอนลงทะเบียนแอปกับ SSO)

ตารางใหม่ที่ต้องมีแทน (ไม่ใช่ role table แต่เป็น user cache/provisioning ตามที่เอกสาร SSO แนะนำ):

**`auth.user`** — `id BIGINT GENERATED ALWAYS AS IDENTITY PK, username TEXT UNIQUE (= JWT sub / sAMAccountName), app_username TEXT NULL (= /userinfo existing_username ถ้า admin ตั้งชื่อเฉพาะแอปนี้ไว้), display_name TEXT (= JWT name), email TEXT (= JWT email), roles TEXT[] (snapshot ล่าสุดจาก JWT roles ตอน login — ใช้แสดงผลเท่านั้น ไม่ใช้ตัดสินสิทธิ์), line_user_id TEXT NULL UNIQUE (LINE userId หลังผูกบัญชี ดู 0d.3/6.4/9b.13, NULL = ยังไม่ผูก), telegram_chat_id TEXT NULL UNIQUE, push_channel_pref TEXT NULL (ใหม่ 30 ก.ค. 2026 — Telegram chat_id + ช่องทางที่ user เลือก ดู 6.4/0g/9b.24), last_login_at TIMESTAMPTZ, is_active BOOLEAN` + audit — upsert แถวนี้ทุกครั้งที่ verify token สำเร็จครั้งแรกของ session (auto-provisioning)

คอลัมน์ username ที่มีอยู่ทั่วเอกสาร (`entry.sale_user_name`, `team_user.user_name`, `approval.action_by`, `notification.target_user_name` ฯลฯ) **ยังคงเป็น TEXT ไม่ผูก FK ตรงๆ กับ `auth.user`** (ตามแบบเดิมที่ออกแบบไว้ก่อน SSO ปิด) — ผูกกันแค่โดย convention (ค่าต้องตรงกับ `auth.user.username`) ไม่ใช่ constraint ระดับ DB เพื่อไม่เพิ่มความเปราะบางถ้า provisioning ล่าช้ากว่าการเขียนข้อมูลแถวแรก (ในทางปฏิบัติไม่เกิดขึ้นเพราะต้อง login ผ่าน SSO ก่อนถึงจะเรียก endpoint ใดๆ ได้อยู่แล้ว)

**สิทธิ์อ่านจาก JWT ของ request นั้นๆ เสมอ (`roles.includes('headsale')`) ไม่อ่านจาก `auth.user.roles` cache** — คอลัมน์นี้ไว้แสดงผล/รายงานเท่านั้น กัน role เปลี่ยนที่ SSO แล้ว cache เก่าไม่ทัน

### A.14 Migration/seed script

แทนโฟลเดอร์ `Deploy_SQL/<วันที่>/` เดิม — ใช้ migration tool ของ ORM ที่เลือก (ดู 9b.4), เนื้อหาที่ต้อง seed เหมือนเดิมทั้งหมด: 13 สถานะ, 10 ทีม, ยี่ห้อคู่แข่ง, ประเภทหน่วยงาน, เหตุผลแพ้/สาเหตุล่ม, `notification_config` เริ่มต้น (`near_due_days = 90`), index ต่างๆ (`registration(org_name_norm)`, `registration(project_name_norm)`, `entry(project_id)`, `entry(sale_user_name, status_id)`, unique partial `entry_revision(entry_id) WHERE is_current_revision`, UNIQUE `entry_revision(entry_id, revision_no)`, `notification(target_user_name, is_read)`, `dealer(name)` (+ `pg_trgm` GIN index), `team_user(user_name)`)

### A.15 ~~AI Chat Assistant — conversation storage~~ → ✂️ ตัดออก (30 ก.ค. 2026 — ดู 0e/0g)

ไม่มีตารางเพิ่มจากหัวข้อนี้ — ช่องทาง push ใช้คอลัมน์บน `auth.user` (A.13) เท่านั้น ไม่มีตารางใหม่

---

## ภาคผนวก B — ร่าง API Contract (REST, Fastify)

> ทุก endpoint: ยืนยันตัวตนผ่าน **session cookie ของเราเอง** (ออกโดย Fastify หลัง OAuth2 code exchange กับ SSO Management — BFF pattern ดู 9c) — Fastify verify JWT ของ SSO (RS256, public key) แล้วอ่าน `roles` (array) จาก payload ที่ `preHandler` hook, request/response เป็น JSON ธรรมดา — **เสนอเลิกใช้ envelope แบบ `BaseRequest`/`BaseResponse` เดิม** (ที่ต้อง include `LoginUserName`/`Success`/`StatusCode` ทุกครั้ง) แล้วใช้ HTTP status code ตามมาตรฐาน (200/201/400/401/403/404/422/500) + error shape เดียว `{ error: { code, message, details? } }` (คนละชั้นกับ error shape ของ SSO เอง `{success,error:{code,message},requestId}` ที่ Fastify เจอตอนคุยกับ SSO — ไม่ผสมกัน) — เป็นแนวทางปกติของ Fastify/REST API สมัยใหม่ และ Fastify generate OpenAPI/Swagger จาก route schema ให้ได้ฟรีถ้าอยากใช้ / กลุ่ม ✅ = ต้องมี role `headsale` (หรือ `admin`) อยู่ใน JWT `roles` array / กลุ่ม 🟣 = ต้องมี role `salemanager`
>
> **สืบทอดหลักการจาก review R6 เดิม (คงไว้ไม่เปลี่ยน ไม่ว่า auth จะเป็นแบบไหน):** ตัวตนและสิทธิ์ของ actor ต้องอ่านจาก session/token ที่ verify แล้วเท่านั้น — field ระบุตัวตนใดๆ ที่ client ส่งมาเองใน body (เทียบเท่า `LoginUserName` เดิม) ใช้ได้แค่เพื่อ logging ห้ามใช้ตัดสินสิทธิ์เด็ดขาด — สิทธิ์ราย endpoint แบบ read/write + record-level ดูตาราง B.2

| # | Method | Path | ใช้กับหน้า | คำอธิบาย |
|---|---|---|---|---|
| 1 | POST | `/list` | ProjectRegister ALL | list ทุกทีม + filter status/**ทีม/Sales/วันคาดจบ** + คำค้น + **sort (team/sales/due, asc-desc)** + paging + จำนวน Entry ต่อ Project |
| 2 | POST | `/to-do-list` | To do list | list ของ actor ปัจจุบัน + ตัวเลขการ์ดสรุป 5 ใบ (คิดฝั่ง server ใน query เดียว) |
| 3 | POST | `/status-update-list` | อัพเดตสถานะ | list ของตัวเอง + flag `canUpdate` (status = presented) |
| 4 | POST | `/detail` | ฟอร์ม/See Detail | ข้อมูล Entry เต็ม: Register + Products + Warranty + PM Tasks + ประวัติพิจารณา |
| 5 | POST | `/save` | ฟอร์ม Register + PM | บันทึกร่าง/ส่งอนุมัติ (`isDraft`) — สร้าง Project+Entry ใหม่ หรือ Entry ใต้ Project เดิม (ส่ง `projectId` มาด้วย) — server ออก `projectCode`/`entryCode` เอง |
| 6 | POST | `/duplicate-check` | ปุ่มตรวจสอบข้อมูลซ้ำ | **ปรับ 27 ก.ค. 2026 (0f.4):** รับ org/project (+ dealer ไว้แสดงผลเฉยๆ) → คืน exact matches ที่ **ตรงครบ 2 field (org+project)** + partial matches (ตรง field เดียว, ใช้ `pg_trgm` ช่วยหาที่พิมพ์ต่างกันเล็กน้อย) + `nextEntrySequence` + รายชื่อ Dealer ของ Entry ที่มีอยู่แล้วในแต่ละ Project ที่ match (ให้ Sales เห็นว่ามีเจ้าไหนยื่นไปแล้วบ้าง) |
| 7 | POST | `/compare` | หน้าเปรียบเทียบ Entry | ทุก Entry ของ Project + PM summary + BOM — server กรองเฉพาะสถานะ eligible สำหรับส่วน compare; **PM summary ต่อ Entry = แถวสรุปโครงการตาม A.8.3 (รวมจาก main item เท่านั้น) และ GP หัก EP ตามนิยามใหม่ (0f.1)**; ป้าย "ต่ำสุด/สูงสุด/ดีที่สุด" คืนเป็น flag ต่อ Entry — **เท่ากันได้หลาย Entry พร้อมกัน ไม่ต้อง tie-break (0f.5)** |
| 8 | POST | `/status-request/save` | ฟอร์มอัพเดตสถานะ 4 แบบ | บันทึกร่าง/ส่งคำขอ won/lost/postpone/edit — **lost ต้องระบุ `lostType` (แพ้/ล่ม); ล่ม = server เปลี่ยนเป็น `closed` ทันที + log ไม่สร้างงานอนุมัติ + สร้าง event notification ถึงหัวหน้า/Manager (✅ 9.24)** — server validate required + transition; เจ้าของ Entry เท่านั้น (B.2) และปฏิเสธเมื่อ Project จบแล้ว (1.5) |
| 9 | POST | `/approve-list` ✅🟣 | หน้าอนุมัติ | list รอพิจารณา + filter ประเภท + ตัวเลข Approve Zone cards — ขอบเขตตาม role (✅ ข้อ 9.17): `headsale` เห็น `waiting`/`waitingWon`/`waitingLost`/`waitingPostpone`/`waitingEdit` ของทีมตาม matrix / `salemanager` เห็นเฉพาะ `waitingSupervisorWon/Lost` ทุกทีม |
| 10 | POST | `/approve` ✅🟣 | Approval Detail | อนุมัติ — server ทำ state transition ตามชั้นของ role (head: `waitingWon→waitingSupervisorWon` ฯลฯ / Manager: `waitingSupervisor*→won/lost`) + apply ผล (postpone → อัพเดตวันคาดจบ + log) |
| 11 | POST | `/reject` ✅🟣 | Approval Detail | ไม่อนุมัติ — บังคับเหตุผล บันทึก `project.approval` (`approverRole` = head/supervisor → แสดงแยกการ์ดฝั่ง Sales) — **review R1: คำขอเป็น `rejected` และ Entry กลับ `presented`; เฉพาะ Reject Register ตั้งต้นที่ Entry เป็น `rejected`** |
| 12 | POST | `/dealer/search` | modal ค้นหา Dealer | ค้นจาก `project.dealer` |
| 13 | POST | `/dealer/add` | modal Dealer ชั่วคราว | เพิ่ม Dealer (`isTemporary = true`) |
| 14 | POST | `/notification` | กระดิ่ง | โครงการวันคาดจบเหลือ 0–89 วัน เรียงใกล้สุดก่อน — scope ตาม role (ข้อ 0.6): Sale = ของตัวเอง / head = ทีมตาม matrix / Manager = ทุก Project; ✅ ยกเว้นสถานะจบแล้ว `won`/`lost`/`closed` (ข้อ 9.21) และ Project ที่จบแล้วตาม 1.5 — รวม event notification จาก `project.notification` ของ actor กลับไปในกระดิ่งเดียวกัน (✅ 9.24) |
| 14d | POST | `/notification/read` | กระดิ่ง | mark event notification ว่าอ่านแล้ว (รายแถวหรือทั้งหมดของ actor) — update `is_read`/`read_date` |
| 14b | POST | `/leader/list` 🟣 | ระบุ Leader Project | Project ที่มี Entry > 1 + สถานะรอระบุ/ระบุแล้ว + จำนวนการ์ดสรุป |
| 14c | POST | `/leader/assign` 🟣 | ระบุ Leader Project (detail) | เลือก Entry เป็น Leader — server อัพเดต `project.registration.leader_entry_id` (source of truth เดียว) + log (✅ ข้อ 9.18: ไม่เปลี่ยนสถานะ Entry/Project ใดๆ, Entry อื่นไม่ถูกแตะ) |
| 15 | GET | `/master/project-status` | ทุกหน้า | master สถานะจาก `project.status` |
| 16 | GET | `/master/project-team` | ฟอร์ม | master ทีมจาก `project.team` |
| 17 | GET | `/master/project-org-type` | ฟอร์ม | ประเภทหน่วยงานจาก `project.org_type` |
| 18 | GET | `/master/competitor-brand` | Bid Result | ยี่ห้อคู่แข่งจาก `project.competitor_brand` |
| 18b | GET | `/master/project-lost-reason`, `/project-collapse-reason` | ฟอร์มไม่ได้งาน | เหตุผลที่แพ้ / สาเหตุที่โครงการล่ม (ข้อ 0.3) |
| 19 | POST | `/entry-revisions` | See Detail | รายการ revision ทั้งหมดของ Entry + เปิดดู revision เก่าแบบ read-only (ข้อ 9.2) |
| 19b | POST | `/entry-revision/submit` | ฟอร์มแก้ไข revision | Sales ส่ง revision ร่างที่แก้เสร็จเข้าอนุมัติรอบ 2 (✅ 9.23) — Entry → `waitingEdit`, revision → `waiting`; หัวหน้าอนุมัติผ่าน `/approve` (`approvalType = editRevision`) → revision เป็น `current` ตัวเดิม `superseded` — 🆕 **รองรับ revision ระดับ Project ด้วย (0f.6): payload ระบุ `revisionScope` = `entry` หรือ `project`; scope `project` ตอนอนุมัติต้องตรวจซ้ำ org+project ใหม่ก่อน apply (A.4b ข้อ 3) และมีผลกับทุก Entry ของ Project นั้น** |
| 20 | POST | `/config/team/list`, `/config/team/save` ✅(admin) | หน้า config | จัดการ `project.team` + matrix `project.team_user` (member/head) |
| 21 | POST | `/config/competitor-brand/save` ✅(admin) | หน้า config | จัดการยี่ห้อคู่แข่ง |
| 22 | POST | `/config/org-type/save` ✅(admin) | หน้า config | จัดการประเภทหน่วยงาน |
| 23 | POST | `/config/notification/get`, `/config/notification/save` ✅(admin) | หน้า config | เกณฑ์วันแจ้งเตือน (+ ช่อง Webhook URL เก็บไว้เผื่ออนาคต — การยิงจริง pending ข้อ 9.15) |
| 24 | POST | `/file/save` (multipart ตรงๆ ผ่าน `@fastify/multipart`), `/file/delete` | ฟอร์ม Register (ไฟล์แนบ) | **ง่ายขึ้นกว่าเดิม** — Fastify รับ multipart ได้ในชั้น API โดยตรง ไม่ต้องเลี่ยงผ่าน MVC action แยกทางแบบเดิม (review R7 เดิมแก้ปัญหาที่ไม่มีอยู่แล้วใน stack ใหม่) — ลำดับยังคงหลักการเดิม: 1) `/save` สร้าง/อัพเดต Entry+Revision ให้ได้ id ก่อน 2) upload ทีละไฟล์หรือหลายไฟล์ในคำขอเดียว: เขียนแถว `project.entry_file` + เก็บไฟล์จริงให้สำเร็จคู่กัน (ที่เก็บ: disk vs object storage — ยังไม่ตัดสินใจ ดู 9b.5; เก็บไม่สำเร็จ → rollback metadata) 3) มี job ล้าง orphan file ที่ไม่มี metadata เป็นระยะ; validate ชนิดไฟล์ + ขนาดรวม ≤ 10 MB ฝั่ง server ก่อนรับ |
| 25 | POST | `/notification/push/link`, `/notification/push/unlink` **[ใหม่ 22 ก.ค. 2026 — ปรับ 30 ก.ค. 2026 ดู 0g]** | หน้าตั้งค่าโปรไฟล์ (ใหม่) | ผูก/ยกเลิกช่องทาง push ของ actor ปัจจุบัน (`channel` = `line` หรือ `telegram`) เข้ากับ `auth.user.line_user_id` / `auth.user.telegram_chat_id` + ตั้ง `push_channel_pref` — **เจ้าของบัญชีเท่านั้นที่ผูกให้ตัวเองได้** (identity จาก JWT ที่ verify แล้ว) — กลไกจริงยังไม่เลือก: LINE (9b.13), Telegram (9b.24 — ฝั่ง Telegram ต้องมี endpoint รับ `/start` เพิ่ม ซึ่งเป็น inbound จาก Telegram ไม่ใช่ client ของเราเอง จึงคุมด้วย secret token ไม่ใช่ session cookie) |

ฝั่ง React เก็บ base URL ของ API ผ่าน environment variable (เช่น `.env` → `VITE_API_BASE_URL`) แทน `appsettings.json > ApiUrl:ProjectRegister` เดิม / การยิง webhook แจ้งเตือน **pending** (ข้อ 9.15) — เมื่อ requirement ชัดค่อยทำเป็น scheduled job/worker ฝั่ง API (ดูหัวข้อ 5) / **push notification ผ่าน LINE/Telegram (ข้อ 0d.3, 0g) เป็น outbound service ภายใน ไม่ใช่ endpoint ที่ client เรียก** — trigger จากการเขียนแถวใหม่ใน `project.notification` (ดู 5/6.4) ผ่าน channel adapter / **ขา inbound มีจุดเดียวคือ webhook รับ `/start` ของ Telegram ตอนผูกบัญชี (ถ้าเลือกแบบ webhook — ดู 9b.24) ซึ่ง verify ด้วย secret token ของ Telegram ไม่ใช่ session ของระบบเรา**

### B.2 Access Matrix — endpoint × role

| Endpoint | sales | headsale | salemanager | admin | Record-level rule |
|---|---|---|---|---|---|
| `/list`, `/detail`, `/compare`, `/entry-revisions`, master ทั้งหมด | ✅ อ่าน | ✅ อ่าน | ✅ อ่าน | ✅ | อ่านได้ทุก Project ตามนโยบายข้อสรุป #4/ความเสี่ยง 8.1 (รวม cost/GP) — เก็บ audit log การเข้าดูหน้า compare; ถ้านโยบายเปลี่ยนให้ตัดที่ response shaping จุดเดียว |
| `/to-do-list`, `/status-update-list`, `/notification`, `/notification/read` | ✅ | ✅ | ✅ | ✅ | คืนเฉพาะข้อมูลใน scope ของ actor (Sale = ตัวเอง / head = ทีมตาม matrix / Manager = ทั้งหมด) — resolve จาก identity ที่ verify แล้ว (SSO) |
| `/save`, upload ไฟล์ (ข้อ 24), `/status-request/save`, `/entry-revision/submit` | ✅ เขียน | ❌ | ❌ | ✅ | **เฉพาะเจ้าของ Entry** (`project.entry.sale_user_name` = identity ที่ verify แล้ว) — ยิง entryId/revisionId ของคนอื่นตรง → 403; สร้างใหม่ผูก actor เป็นเจ้าของเสมอ |
| `/approve-list`, `/approve`, `/reject` | ❌ | ✅ | ✅ | ✅ | head: เฉพาะงานของทีมที่ config ใน `project.team_user` (ยิงข้ามทีม → 403); manager: เฉพาะสถานะ `waitingSupervisorWon/Lost` (ทุกทีม) |
| `/leader/list`, `/leader/assign` | ❌ | ❌ | ✅ | ✅ | เฉพาะ Project ที่มี Entry > 1 |
| `/dealer/search`, `/dealer/add` | ✅ | ✅ | ✅ | ✅ | `dealer/add` บันทึกผู้สร้างจาก identity ที่ verify แล้ว |
| `/config/**` | ❌ | ❌ | ❌ | ✅ | — |

- ทุก endpoint ตรวจ role จาก JWT ที่ verify แล้ว (SSO, `roles` array) + record-level rule ตามตารางนี้**ฝั่ง server เสมอ** — การซ่อนปุ่ม/เมนูฝั่ง UI เป็นแค่ UX ไม่ใช่การคุมสิทธิ์ — **role ในตารางนี้ (sales/headsale/salemanager/admin) ต้องขอให้ SSO admin ตั้งค่า `group_role_map` ของ client_id ระบบนี้ให้ตรงทั้ง 4 ชื่อตอนลงทะเบียนแอป (ดู 9c) — ไม่ใช่สมมติฐานอีกต่อไป แต่เป็น config ที่ต้องประสานทำจริง**
- Scenario ทดสอบ: D13 (role-level), D18 (matrix ทีม), D28 (record-level + ปลอมตัวตนใน body)

---

## ภาคผนวก C — Field Mapping: Prototype → DB

### C.1 ฟอร์ม Register (`Role_Sale.html` #registerPage)

| Field ใน Prototype | Element | ปลายทาง DB |
|---|---|---|
| ลำดับ (Auto) | `#fSeq` | `project.entry.entry_code` (server ออกให้) |
| วันที่ (Auto) | `#fDate` | `project.entry.created_at` |
| ทีม | `#fTeam` | `project.entry_revision.team_id` |
| Sales | `#sales` | `project.entry.sale_user_name` |
| แนบไฟล์เอกสารยื่นงาน | `input[type=file]` | `project.entry_file` — หลายไฟล์ (เอกสาร/PDF, รวม ≤ 10 MB), rename เป็น `{project_code}_{TIMESTAMP}_{Seq}` — upload ผ่าน `@fastify/multipart` ในคำขอเดียวกับข้อมูลฟอร์มได้ (ดู B ข้อ 24) |
| วันคาดจบ | `#fDue` | `project.entry_revision.expect_finish_date` |
| ชื่อหน่วยงาน | `#fOrg` | `project.registration.org_name` (+norm) |
| ชื่อโครงการ | `#fProject` | `project.registration.project_name` (+norm) |
| ประเภทหน่วยงาน | `#fOrgType` | `project.registration.org_type_id` → `project.org_type` |
| Dealer | `#dealerText` + modal | `project.entry_revision.dealer_id` + `dealer_snapshot` |
| เงื่อนไขการขาย | `#fCondition` | `project.entry_revision.sale_condition` |
| ข้อมูลสินค้า (แถว) | `.product-row` | `project.entry_product` (model, group, ชนิดแบต, qty batt, batt bank, option, qty, unit_price, amount) |
| ระยะเวลารับประกัน | `.warranty` | `warranty_lifetime, warranty_years, warranty_start_date, warranty_end_date` |

### C.2 ฟอร์มอัพเดตสถานะ (4 แบบ → `project.status_request` ตารางเดียว)

| ฟอร์ม | Field Prototype | คอลัมน์ |
|---|---|---|
> **ยึด "โซนอัพเดตสถานะในหน้า Detail" (`#statusUpdateZone`) เป็นหน้าจอจริงชุดเดียว (✅ 0f.8)** — prototype ยังมี modal `#statusUpdateModal` ค้างอยู่ในไฟล์ (ฟอร์ม `formWon`/`formLost`/`formPostpone`/`formEdit` + ช่อง `wonRef` เลขที่ PO, `wonAmount` มูลค่างาน, `wonDate` วันที่ได้งาน) แต่ **ไม่มีปุ่มไหนเรียกใช้เลย = dead UI ไม่ implement และไม่เพิ่มคอลัมน์รองรับ**

| ฟอร์ม | Field Prototype (id จริงในโซนหน้า Detail) | คอลัมน์ |
|---|---|---|
| ได้งาน (`won`) | `wonAnalysis, wonCompetitorBrand, wonCompetitorModel, wonCompetitorPrice, wonInspector, wonResultDate` | `sale_analysis, competitor_brand, competitor_model, competitor_price, inspector_name, result_date` — required ทุกตัว |
| ไม่ได้งาน → **แพ้** (`lost` + `lostType='lose'`) | เลือกการ์ด "แพ้" → `lostAnalysis, lostCompetitorBrand, lostCompetitorModel, lostCompetitorPrice, lostInspector, lostResultDate` **+ 🆕 ช่อง "เหตุผลที่แพ้" (dropdown) ที่ต้องเพิ่มเข้าไป** | `lost_type='lose'`, **`lost_reason_id`** (dropdown จาก `project.lost_reason`), `sale_analysis` (= วิเคราะห์สาเหตุที่แพ้ แบบ free text), `competitor_brand/model/price`, `inspector_name`, `result_date` — required ทุกตัว → เข้า flow อนุมัติ 2 ชั้น |
| ไม่ได้งาน → **ล่ม** (`lost` + `lostType='collapse'`) | เลือกการ์ด "ล่ม" → `detailCollapseReason`, `detailCollapseDate`, `detailCollapseNote` — required ทั้ง 3 | `lost_type='collapse'`, `collapse_reason_id`, `collapse_date`, `collapse_note` → server เปลี่ยนสถานะเป็น `closed` ทันที (ไม่มีการอนุมัติ) |
| เลื่อนวันคาดจบ (`postpone`) | `detailOldDue, detailNewDue, detailPostponeReason` | `old_expect_date, new_expect_date, postpone_reason` |
| แก้ไขข้อมูล (`edit`) | `detailEditField, detailEditValue, detailEditReason` | `edit_field, edit_new_value, edit_reason` — หัวข้อที่เลือกได้ 6 ค่า: ชื่อหน่วยงาน / ชื่อโครงการ / Dealer / เงื่อนไขการขาย / ข้อมูลสินค้า / ระยะเวลารับประกัน → **2 ค่าแรกเปิด revision ระดับ Project (A.4b) ที่เหลือเปิด revision ระดับ Entry** (✅ 0f.6); 1 คำขอ = 1 หัวข้อ ตาม prototype (แก้หลายเรื่องยื่นหลายคำขอ) |

> **🆕 27 ก.ค. 2026 (✅ 0f.7) — ช่องเดียวที่เพิ่มจาก prototype:** ฟอร์ม "แพ้" ในหน้าจริงมีแต่ช่องวิเคราะห์แบบ free text ไม่มี dropdown "เหตุผลที่แพ้" (ช่อง `lostReasonType` ที่มีอยู่ใน modal ซึ่งเป็น dead UI) — ข้อสรุปรอบนี้คือ **เก็บทั้งคู่**: dropdown (ราคา / Specification / ระยะเวลาส่งมอบ / เงื่อนไขการขาย / อื่นๆ) ไว้ทำรายงานสาเหตุการแพ้ + free text ไว้เก็บบริบท → ต้องเพิ่ม dropdown เข้าไปในโซนอัพเดตสถานะของหน้า Detail (ทั้ง `Role_Sale` และหน้าอนุมัติฝั่งหัวหน้า/Manager ต้องแสดงค่านี้ด้วย)

### C.3 ตาราง Project Management → `project.entry_task` (**ยึด `Template_ProjectManagement.xlsx` ไม่ใช่ `taskRow` ของ prototype — ✅ 0f.1/0f.2**)

| Template (sheet `หลายรายการ`) | ปลายทาง |
|---|---|
| R1 `ชื่อหน่วยงาน By ชื่อเซลล์` / R4 `ปี ?? : ชื่องาน/ชื่อโครงการ : ? Ys`, `ชื่อเซลล์`, `ชื่อ Dealer` | **ไม่ใช่ข้อมูลที่กรอกในตารางนี้** — ดึงจาก Register/Entry (`registration.org_name`/`project_name`, `entry.sale_user_name`, `entry_revision.dealer_snapshot`, `warranty_years`) มาแสดงเป็นหัวตาราง |
| R3–R4 (แถวสรุปตัวเลข) | **ไม่เก็บใน DB** — คำนวณตอนแสดงผลตาม A.8.3 (เป็นตัวเลขชุดเดียวกับการ์ดหน้าเปรียบเทียบ Entry) |
| R5, R9 (`ลำดับ` + `รายการ/สเปก`) | `entry_task` `task_level = 1` (main item) — ตัวเลขทุกช่อง roll-up |
| R6–R8, R10–R12 (บรรทัดสเปก) | `entry_task` `task_level = 2` (spec line) — ระดับที่กรอกจริง |
| คอลัมน์ A–R | ตาม A.8.2 (ลำดับ = คำนวณจาก `parent_task_id + seq_no` ตอนแสดงผล ไม่เก็บเป็นข้อความ) |
| หมายเหตุในไฟล์ (comment/สีเซลล์) | `cost_quote_date` (*"ราคา ณ วันที่เท่าไร"*), `ep_quote_date`/`ep_source` (*"ราคาต้องได้จากจัดส่งเท่านั้น + ลงวันที่ที่ได้ราคามา"*), กติกา OC (*"ช่องขาวคิด GP ไม่รวม OC / ช่องสีเทา คิดรวม OC"*) → A.8.3 |

---

## ภาคผนวก D — Test Scenarios หลัก (Acceptance Criteria)

| # | Scenario | ผลที่คาดหวัง |
|---|---|---|
| D1 | Sales สร้าง Register ใหม่ + บันทึกร่าง | สถานะ `draft`, แก้ไขต่อได้, ยังไม่โผล่หน้าอนุมัติหัวหน้า |
| D2 | ส่งอนุมัติโดยข้อมูล Register/PM ไม่ครบ | server ปฏิเสธพร้อมระบุ field ที่ขาด (ไม่พึ่ง client validation อย่างเดียว) |
| D3 | ส่งอนุมัติสำเร็จ → หัวหน้าอนุมัติ | `waiting` → `presented`, มีแถวใน StatusLog + Approval history |
| D4 | หัวหน้า Reject โดยไม่กรอกเหตุผล | ระบบไม่ให้ผ่าน; กรอกแล้ว → `rejected` + เหตุผลแสดงฝั่ง Sales ในหน้า See Detail |
| D5 | **(ปรับ 0f.4)** ตรวจซ้ำ: org+project ตรงครบ 2 field (ต่าง case/ช่องว่าง) **โดยที่ Dealer เป็นคนละเจ้ากับ Entry เดิม** | เจอ exact match, เสนอยื่นเป็น Entry ลำดับถัดไป, ยืนยันแล้วได้ `entryCode = PRJ-xxxx-E{n}` — **Dealer ต่างกันต้องไม่ทำให้กลายเป็น Project ใหม่** (เคสหลักของ business B2B) |
| D6 | **(ปรับ 0f.4)** ตรวจซ้ำ: ตรงแค่ field เดียว (org หรือ project) | แสดงรายการซ้ำบางส่วน + เตือน แต่สร้าง Project ใหม่ได้; Dealer ซ้ำเฉยๆ ไม่นับเป็นข้อมูลซ้ำอีกต่อไป |
| D7 | สองคนยืนยันยื่น Entry ใต้ Project เดียวพร้อมกัน | ได้ `entrySequence` ไม่ชนกัน (UNIQUE constraint + retry) |
| D8 | อัพเดตสถานะกดได้เฉพาะ `presented` | Entry สถานะอื่นปุ่ม disable และ server ปฏิเสธถ้ายิงตรง |
| D9 | ส่ง "ได้งาน" ครบทุก field → หัวหน้าอนุมัติ → **Manager อนุมัติ** | `presented` → `waitingWon` → `waitingSupervisorWon` → **`won`** (จบใน Phase เดียวตาม updated-flow) |
| D10 | ส่ง "เลื่อนวันคาดจบ" → หัวหน้าอนุมัติ | วันคาดจบใหม่ถูก apply, วันเดิมอยู่ใน `status_log`, สถานะกลับ `presented` |
| D11 | หน้าเปรียบเทียบ: Project มี Entry สถานะ `draft`/`waiting` ปน **และมี 2 Entry ที่ราคาขาย/GP เท่ากันเป๊ะ** | ส่วน compare PM แสดงเฉพาะ Entry สถานะ eligible; ส่วนตาราง Register แสดงทุก Entry; **Entry ที่ค่าเท่ากันติดป้าย "ต่ำสุด/สูงสุด/ดีที่สุด" พร้อมกันทั้งคู่ ไม่ใช่เลือกมาตัวเดียว (✅ 0f.5)** |
| D12 | การ์ด To do list 5 ใบ | ตัวเลขตรงกับ filter จริงทุกใบ รวม "ใกล้ครบกำหนด" = เหลือ 0–89 วัน |
| D13 | Role: Sales ธรรมดาเข้าเมนู/URL อนุมัติ | เมนูไม่แสดง + route/API ปฏิเสธ (ตรวจ role ฝั่ง server) |
| D14 | ปิดการเปิดใช้งานเมนูจาก config | เมนูแสดงจาง กดไม่ได้ |
| D15 | กระดิ่งแจ้งเตือน | นับเฉพาะ 0–89 วัน เรียงใกล้สุดก่อน กดแล้วเปิด Detail ถูกตัว |
| D16 | เลขรัน `PRJ-YYYY-MM-XXXX` ข้ามเดือน / ยิงพร้อมกัน | เดือนใหม่ reset เป็น 0001, ภายในเดือนไม่ซ้ำไม่ข้ามเลข (ข้อสรุป 9.11) |
| D17 | Flow แก้ไขข้อมูลครบวงจร (✅ 9.23): หัวหน้าอนุมัติคำขอ → Sales แก้ → ส่งอนุมัติซ้ำ | อนุมัติคำขอ → เกิด revision ร่าง (`revisionStatus='draft'`, **current ยังเป็นตัวเดิม** — list/compare ไม่เปลี่ยน) → Sales เจ้าของแก้เฉพาะหัวข้อที่ขอ → ส่ง → Entry `waitingEdit` รอบ 2 → หัวหน้าอนุมัติ → revision ใหม่เป็น `current` ตัวเดิม `superseded` เปิดดู read-only; หัวหน้า reject รอบ 2 → revision กลับ `draft` + Entry กลับ `presented` แก้ต่อได้ |
| D18 | สิทธิ์มองเห็นของ `headsale` ตาม matrix + ย้ายทีม | หัวหน้าเห็น/อนุมัติเฉพาะงานของทีมที่ config ใน `project.team_user` (ยิง API ตรงต้องถูกปฏิเสธ); ย้าย Sales ไปทีมใหม่ → งานทั้งหมดของ Sales ไปขึ้นกับหัวหน้าทีมใหม่**ทันที** (ข้อ 9.16) |
| D19 | อัปโหลดไฟล์แนบหลายไฟล์ | รับเฉพาะเอกสาร/PDF, ผลรวมทุกไฟล์ต่อ Entry เกิน 10 MB ต้องถูกปฏิเสธ (ตรวจฝั่ง server ด้วย), ไฟล์จริง rename เป็น `{project_code}_{TIMESTAMP}_{Seq}.{ext}` (กัน 2 ไฟล์ชนกันในวินาทีเดียวกัน) แต่หน้าจอแสดงชื่อเดิมที่ user ตั้ง |
| D20 | แก้ค่าเกณฑ์แจ้งเตือนในหน้า config (เช่น 90 → 60 วัน) | กระดิ่ง/การ์ด "ใกล้ครบกำหนด" ใช้เกณฑ์ใหม่ทันทีทุกจุดที่อ้างเกณฑ์นี้ (webhook pending — ยังไม่ต้องทดสอบ) |
| D21 | ส่ง "ไม่ได้งาน → แพ้" ครบทุก field → หัวหน้าอนุมัติ → Manager อนุมัติ | `presented` → `waitingLost` → `waitingSupervisorLost` → `lost`; เหตุผลที่แพ้ + Bid Result อยู่ครบใน request; Manager reject → **Entry กลับ `presented`** คำขอเป็น `rejected` (review R1) + เหตุผลแสดงการ์ด "Supervisor/พี่บี" ฝั่ง Sales — Sales ส่งคำขอใหม่ได้ทันที |
| D22 | ส่ง "ไม่ได้งาน → ล่ม" (สาเหตุ/วันที่/รายละเอียดครบ) | สถานะเป็น `closed` **ทันที** ไม่มีงานเข้าหน้าอนุมัติใคร, มี log ผู้กด+เวลา; **เกิดแถว event ใน `project.notification` ถึงหัวหน้าทีมของ Sales (ตาม matrix) และทุก user role `salemanager` — แสดงในกระดิ่งและ mark อ่านได้ (✅ 9.24)**; กรอกไม่ครบ → server ปฏิเสธ |
| D23 | Manager ระบุ Leader ของ Project ที่มี 3 Entry | เลือกได้ 1 Entry → `project.registration.leader_entry_id` ถูกบันทึก (source of truth เดียว; ✅ 9.18: Entry อื่นไม่ถูกเปลี่ยนสถานะ และยังเห็นในหน้า compare); เลือก Entry อื่นซ้ำ → ค่าย้ายไปตัวใหม่ เหลือ Leader ตัวเดียวเสมอ; role อื่นยิง `/leader/assign` ตรง → ถูกปฏิเสธ (B.2) |
| D24 | กระดิ่งแจ้งเตือนแยกตาม role | Login เป็น Sale เห็นเฉพาะงานตัวเอง / หัวหน้าเห็นงานทีมตาม matrix / Manager เห็นทุก Project — สถานะจบแล้ว (`won`/`lost`/`closed` — ✅ ข้อ 9.21) ไม่ถูกนับ |
| D25 | หน้า ProjectRegister ALL: sort ทีม/Sales/วันคาดจบ + filter ทีม/Sales/วันคาดจบ พร้อม paging | ผล sort/filter ถูกต้องข้ามหน้า (ทำฝั่ง server) + ปุ่ม "ล้าง Filter" reset ครบทุกช่อง |
| D26 | Project-level lifecycle (✅ 9.22): Project มี 3 Entry แล้ว Entry หนึ่งถึง `won` | `project.registration.project_status` เปลี่ยนเป็น `won` ทันที + log ระดับ Project; Entry อื่นคงสถานะเดิม (9.18) แต่ส่งคำขอเปลี่ยนสถานะใหม่ถูก server ปฏิเสธ และทั้ง Project หายจากแจ้งเตือน near-due; กรณีทุก Entry `closed` → `project_status = closed`, มี `lost` ปนและไม่มี `won` → `lost` |
| D27 | Reject คำขอเปลี่ยนสถานะ (review R1): หัวหน้า reject คำขอ `waitingWon` | Entry กลับ `presented` (ปุ่มอัพเดตสถานะกดได้อีกครั้ง), คำขอเป็น `requestStatus = rejected` + เหตุผล, การ์ด "โดน Reject" ใน To do list นับรายการนี้; EntryStatus `rejected` เกิดเฉพาะ Reject Register ตั้งต้น (D4) |
| D28 | Record-level authorization (review R6): Sales A ยิง `/save` / `/status-request/save` ด้วย entryId ของ Sales B หรือปลอมตัวตนใน body | ถูกปฏิเสธ 403 ทุกกรณี — server ตัดสิทธิ์จาก identity ที่ verify แล้ว (session/token ของ SSO) เท่านั้น ไม่อ่านตัวตนจาก request body (ดู B.2) |
| D29 | **(ใหม่ — ปิดตาม 9c)** Auth ผ่าน SSO: access token หมดอายุระหว่างใช้งาน / refresh token ถูกใช้ซ้ำ (replay) / signature ไม่ตรง | Access token หมดอายุ → Fastify ตรวจ `exp` แล้วพยายาม refresh อัตโนมัติ 1 ครั้งด้วย refresh token ที่เก็บไว้ฝั่ง server ก่อน แล้ว retry request เดิม; refresh token ถูกใช้ซ้ำ (ตัวที่ถูก revoke ไปแล้วจากการ rotate ครั้งก่อน) → SSO ปฏิเสธ (`TOKEN_REVOKED`/`INVALID_GRANT`) → บังคับ logout + เคลียร์ session cookie + redirect ไป login ใหม่ทั้งหมด (ห้าม silent-fail); JWT signature ไม่ตรง public key (`TOKEN_INVALID`) → ปฏิเสธทันที ไม่ retry |
| D30 | **(ใหม่ 22 ก.ค. 2026 — ดู 0d.1/0d.2, สมมติฐานยังไม่ยืนยัน)** เปิดหน้า ProjectRegister ALL / To-do list บนจอมือถือ | ข้อมูล/ฟังก์ชันครบเหมือน desktop ทุกอย่าง (sort/filter/paging เรียก endpoint เดียวกัน) แต่แสดงผลเป็น card list แทนตารางแนวนอน — ไม่มีคอลัมน์ไหนหายไปจากที่ desktop มี เทียบกันแล้วแค่จัด layout ต่างกัน |
| D31 | **(ใหม่ — ปรับ 30 ก.ค. 2026 ดู 0d.3/0g, สมมติฐานยังไม่ยืนยัน)** ผู้อนุมัติ 3 คน: คนที่ผูก LINE, คนที่ผูก Telegram, คนที่ยังไม่ผูกช่องทางใดเลย — มีคำขอ "รออนุมัติ" ใหม่เข้ามาในทีม | คนที่ผูก LINE ได้ Flex Message / คนที่ผูก Telegram ได้ข้อความพร้อม inline keyboard — **เนื้อหาเท่ากันทั้ง 2 ช่องทาง (project code + ประเภทคำขอ ไม่มีราคา/GP ตาม 8.18)** และปุ่ม deep-link เปิดไปหน้า Approval Detail ของรายการนั้นตรงๆ; คนที่ยังไม่ผูก **ไม่ได้รับ push เลยแต่กระดิ่งในแอปยังเห็นปกติ**; push ล้มเหลวช่องทางใดช่องทางหนึ่ง (เกิน quota/บล็อก bot/ผู้ใช้ลบแชท) **ไม่ทำให้การสร้างคำขออนุมัติล้มเหลว และไม่ทำให้ช่องทางอื่นไม่ถูกส่ง** |
| D36 | **(ใหม่ 27 ก.ค. 2026 — ✅ 0f.1/0f.2)** กรอกตาราง PM ตามตัวอย่างใน `Template_ProjectManagement.xlsx`: main item 2 รายการ, spec line รายการละ 3 บรรทัด, main item ที่ 2 มีรายการ EP ชนิด **OC** ปนอยู่ | ตัวเลขทุกช่องต้องตรงกับ template: `Amt = Qty×@`; main item roll-up จาก spec line ครบทุกคอลัมน์; **`GP = ราคาขาย − ต้นทุน − EP`** ทุกระดับ; **GP 2 ชุดตรงกับไฟล์เป๊ะ: แถวขาว (spec) `2,863,286.30` (GP% 56.14 — ก่อนหัก OC) / แถวเทาอ่อน (main item 2) `2,713,286.30` (GP% 53.20 — หลังหัก OC 150,000) / แถวเทาเข้ม (สรุป) `5,426,572.60`**; ค่าต่อหน่วยที่แถวสรุป = `Amt ÷ Qty` (ไม่ใช่ผลบวกของ @); **ยอดรวมทั้ง Entry รวมจาก main item เท่านั้น ห้ามนับ spec line ซ้ำ**; **ช่องที่เป็นยอดรวมทุกช่อง (รวม GP) แก้ด้วยมือไม่ได้ และอัปเดตสดทันทีที่พิมพ์ที่ spec line โดยไม่ต้องกดปุ่มหรือบันทึกก่อน**; ลบ spec line 1 บรรทัด → แถว main + แถวสรุป + การ์ดหน้าเปรียบเทียบเปลี่ยนตามทันที; main item ที่ยังไม่มี spec line เลย → กรอกที่แถว main เองได้ พอเพิ่ม spec line แรกระบบสลับเป็น auto พร้อมเตือนก่อนทับค่าเดิม; ยิง `/save` ด้วยตัวเลข GP/ยอดรวมที่จงใจผิด → server ทิ้งค่าที่ส่งมาแล้วคำนวณใหม่เสมอ |
| D37 | **(ใหม่ 27 ก.ค. 2026 — ✅ 0f.6)** ส่งคำขอ "แก้ไขข้อมูล → ชื่อโครงการ" บน Project ที่มี 3 Entry ของ Sales 3 คน แล้วหัวหน้าอนุมัติ | เกิด **`registration_revision` ร่าง** (ไม่ใช่ `entry_revision`), current ยังเป็นค่าเดิมจนกว่าจะอนุมัติรอบ 2; UI เตือนผู้ขอว่ากระทบทุก Entry; อนุมัติรอบ 2 แล้ว **ชื่อโครงการเปลี่ยนพร้อมกันทั้ง 3 Entry** + `project_name_norm` อัพเดต + log ระดับ Project; ถ้าชื่อใหม่ไปชนกับ Project อื่นที่มีอยู่ (org+project ซ้ำ) → **ปฏิเสธพร้อมชี้ Project ที่ชน** |

---

## ภาคผนวก E — ~~ขอบเขต Phase 2 (Supervisor / พี่บี)~~ → **ถูกรวมเข้า Phase 1 แล้ว (updated-flow 18 ก.ค. 2026)**

หัวข้อนี้เดิมเป็น scope ที่กันไว้ทำรอบหน้า — updated-flow ดึงเข้ามาทำรอบนี้ทั้งหมด สถานะรายข้อ:

- ~~เมนู + หน้า "รอ Supervisor อนุมัติ"~~ → **ทำรอบนี้** — มี Prototype แล้ว (`Role_Manager_Lastest.html`) เหลือสรุปชื่อ role (ข้อ 9.20)
- ~~Transition `waitingSupervisorWon/Lost` → `won`/`lost`~~ → **ทำรอบนี้** (ดู 1.4, D9, D21)
- เหตุผล Reject ของ Supervisor แสดงในการ์ด `sales-reason-card manager` → **ใช้งานจริงรอบนี้** — โครง DB (`approverRole = 'supervisor'`) ตามที่ออกแบบไว้ ไม่ต้อง migrate
- "ปิดโครงการ" (`closed`) → **ใช้งานจริงรอบนี้ผ่านทาง "ล่ม"** (ข้อ 0.3 — กลับข้อสรุปเดิม 9.12); ยังไม่มีปุ่มปิดโครงการ standalone แบบอื่น
- **สิ่งที่ยังเป็นของรอบหน้า (Phase ถัดไปตัวจริง):** การยิง webhook แจ้งเตือน (ข้อ 9.15 — pending) และเลข **SYS No.** ของอีกระบบ (ข้อ 9.19 — ยังไม่ทำ)

---

*เอกสารนี้อัปเดตล่าสุด: 30 ก.ค. 2026 (รอบ 11 — ตัด AI Chat Assistant ออก + ช่องทาง push เหลือ LINE/Telegram) — รอบ 2 ปรับตาม `updated-flow/` (เพิ่ม Role Manager/พี่บีเข้า Phase 1, หน้า "ระบุ Leader Project", ทางแยก แพ้/ล่ม → `closed`, กติกาแจ้งเตือนตาม role, sort/filter หน้า list); รอบ 3 ปิดคำถาม 9.17–9.21; รอบ 4 ปิด 8 ประเด็นจากการ review (สรุปที่ 0b): แยก EntryStatus/RequestStatus, เพิ่ม Project-level lifecycle, workflow แก้ไขข้อมูลต้องอนุมัติซ้ำ, แยกตาราง Entry/EntryRevision + Leader ชี้ Entry ID คงที่, event notification, Access Matrix, file upload contract, ชื่อตาราง canonical ชุดเดียว — คำถาม business ปิดครบทั้ง 24 ข้อ; รอบ 5 (21 ก.ค. 2026): เปลี่ยน tech stack ทั้งหมดเป็น React + Node.js/Fastify + PostgreSQL + SSO, แยกเป็นระบบ standalone ไม่ผูกกับ Syndome CRM เดิม (สรุปที่ 0c) — เขียนใหม่หัวข้อ 3–9 + ภาคผนวก A–C ให้ตรง stack ใหม่, เปิดคำถามใหม่ 10 ข้อเรื่อง stack/infra/auth ที่ยังไม่ปิด (หัวข้อ 9b) — ยังปิด spec ส่วน auth ไม่ได้จนกว่าจะมีรายละเอียด SSO; รอบ 6 (21 ก.ค. 2026): ปิดคำถาม SSO (9b.1–9b.3) ตามเอกสาร "SSO Management — App Integration Guide" ที่ผู้ใช้ให้มา (สรุปที่ 9c ใหม่) — OAuth2 Authorization Code Flow + JWT RS256, role มาจาก JWT `roles` claim ตรงๆ (ไม่มีตาราง role local, เพิ่ม `auth.user` สำหรับ provisioning), เหลือแค่ BFF vs token-passthrough เป็นทางเลือกภายในทีม (ไม่ blocking) — ปรับหัวข้อ 4.3, 5, 6.2, ภาคผนวก A.13, B intro/B.2, ความเสี่ยง 8.11 (ปิด) + 8.14 (ใหม่), ประมาณการงานหัวข้อ 10 (เพิ่ม Auth/SSO 6–9 man-day เข้ารวม) ให้ตรงกันทั้งหมด; รอบ 7 (22 ก.ค. 2026): เพิ่มขอบเขตใหม่ Mobile Responsive + แจ้งเตือนอนุมัติผ่าน LINE Flex Message ตามคำขอผู้ใช้ (สรุปที่ 0d ใหม่) — ไม่มี Prototype/เอกสารอ้างอิงรองรับมาก่อนแบบรอบ 5/6 จึงเป็นสมมติฐานล้วนๆ ที่ต้องยืนยันก่อน implement: responsive web ชุดเดียว (ไม่ใช่แอป native), ตาราง PM/compare ต้องออกแบบใหม่เป็น card/accordion บนมือถือ (จุดยากสุด), LINE ผูกกับ event notification เดิมแบบ push ทางเดียว — เปิดคำถามใหม่ 5 ข้อยังไม่ปิดเลย (9b.11–9b.15: responsive pattern, LINE OA ตัวไหน, วิธีผูกบัญชี, one-way vs interactive, event ไหนบ้างที่ push) — เพิ่มความเสี่ยงใหม่ 8.15–8.18 (ออกแบบมือถือยาก, LINE quota, ผูกบัญชีไม่ครบ, ข้อมูลหลุดใน Flex Message), endpoint ใหม่ 25 (`/notification/line/link`), scenario ใหม่ D30–D31, ประมาณการงานเพิ่ม Responsive 5–8 + LINE 4–6 man-day (~67–99 → ~76–113 man-day); **รอบ 8 (22 ก.ค. 2026): เพิ่มขอบเขตใหม่ AI Chat Assistant สำหรับค้นหา/สรุปข้อมูลโครงการผ่านแชท ตาม requirement FR-01–FR-11 ที่ผู้ใช้ระบุในแชท (ไม่ใช่เอกสารแนบ — สรุปที่ 0e ใหม่)** — มี requirement ละเอียดกว่ารอบ 7 (มีตัวอย่าง input/output ครบ 11 ข้อ) แต่ยังไม่มีรายละเอียดระดับ implementation (LLM provider/data policy) แบบที่ SSO เคยมี: ออกแบบเป็น **tool-use/function-calling ห่อ endpoint อ่านข้อมูลที่มีอยู่แล้วทั้งหมด** (ไม่ทำ vector search/RAG แยก), บังคับ authorization ต่อ tool call เดียวกับ REST endpoint ปกติทุกจุด, ห้าม LLM สร้างตัวเลข/ข้อเท็จจริงเอง (กัน hallucination), chat เป็น read-only surface ล้วนๆ ไม่มี action เขียนในแชท (ทุก action deep-link กลับไปหน้าเว็บ) — เปิดคำถามใหม่ 6 ข้อยังไม่ปิดเลย (9b.16–9b.21: LLM provider/DPA [blocking], conversation retention, streaming, rate limit, aggregate freshness, ยืนยัน tool-use เพียงพอหรือต้อง RAG) — เพิ่มความเสี่ยงใหม่ 8.19–8.24 (ข้อมูลอ่อนไหวส่งออก LLM ภายนอก [สูงสุด], hallucination, role-leakage ผ่านแชท, ต้นทุน/latency, privacy ของ conversation log, ความกำกวมภาษาไทย), ตารางใหม่ `chat_session`/`chat_message` (A.15), endpoint ใหม่ 26/26b, scenario ใหม่ D32–D35, ประมาณการงานเพิ่ม Chat orchestration 8–12 + Conversation storage/aggregate 3–4 + Chat UI 4–6 + Security/policy 3–5 man-day (~76–113 → ~95–143 man-day)**; **รอบ 9 (23 ก.ค. 2026): เพิ่ม mockup ต้นแบบหน้าจอมือถือ (AI Chat Assistant + LINE Push) ที่ทำขึ้นเองระหว่างงานนี้ (สรุปที่ 4.6 ใหม่, ไฟล์ `updated-flow/ChatAssistant_Mobile_Prototype.html`) เพื่อสาธิต UX ของ 0d/0e ให้เป็นรูปธรรม — ไม่ใช่ requirement/ขอบเขตใหม่, ไม่ปิดคำถามค้างข้อใดเลย (9b.11/9b.12–9b.15/9b.16–9b.21 ยังเปิดอยู่ทั้งหมดเหมือนเดิม), ไม่เพิ่ม risk ใหม่, ไม่กระทบประมาณการงานหัวข้อ 10 — เป็นภาพประกอบสำหรับเก็บ feedback จากผู้ใช้เท่านั้น***; **รอบ 10 (27 ก.ค. 2026): ผู้ใช้ส่ง `prototype/Template_ProjectManagement.xlsx` (ไฟล์ที่ทีมขายกรอกงานจริง) + ตอบคำถามค้างจากรอบ review เอกสาร (สรุปที่ 0f ใหม่)** — **เขียนภาคผนวก A.8 ใหม่ทั้งหัวข้อให้ตรง template**: 2 ระดับ (main item → spec line) + แถวสรุปโครงการที่คำนวณตอนแสดงผล, 18 คอลัมน์ตาม template, **นิยาม GP ใหม่ `GP = ราคาขาย − ต้นทุน − EP` (เดิมเอกสารตามสูตร prototype ที่ไม่หัก EP) และ GP เป็นค่า derived ห้ามกรอกมือ**, กติกา OC (OC = Overriding Commission ค่าคอม Dealer ซึ่งเป็นรายการหนึ่งใน EP → GP 2 ชุด: แถวขาว = ก่อนหัก OC / แถวเทา = หลังหัก OC ตามตัวเลขจริงในไฟล์ — ผู้ใช้ยืนยันทิศทางแล้ว ดู A.8.3.1), บันทึกความหมายของสีพื้น/ชั้นการ group (ขาว → เทาอ่อน → เทาเข้ม) ไว้ใน A.8.1, **กำหนดให้ทุกช่องที่เป็นยอดรวมคำนวณอัตโนมัติ + read-only เหมือนสูตรใน Excel และอัปเดตสดทันทีที่พิมพ์ (A.8.3.2 ใหม่ — ตารางระบุครบว่าช่องไหนกรอกมือ/ช่องไหน auto ในทั้ง 3 ชั้น รวมเคส main item ที่ไม่มีรายการย่อย)**, เพิ่ม master `project.ep_item_type` (`is_oc`) + field `cost_quote_date`/`ep_quote_date`/`ep_source` ตาม comment ในไฟล์ template; **Project identity เหลือ 2 field (org+project) — Dealer อยู่ระดับ Entry ตาม business B2B ที่ Dealer หลายเจ้าขอราคางานเดียวกัน** (แก้ 1.1, A.4, endpoint 6, D5–D6); **เพิ่ม revision ระดับ Project `project.registration_revision` (A.4b ใหม่)** สำหรับการแก้ชื่อหน่วยงาน/ชื่อโครงการที่ทุก Entry ใช้ร่วมกัน (แก้ 1.4, endpoint 19b, D37 ใหม่); ฟอร์ม "แพ้" เก็บทั้ง dropdown เหตุผลที่แพ้ + free text (เพิ่ม dropdown เข้าหน้าจอ — จุดเดียวที่เพิ่มจาก prototype นอกจากตาราง PM); ยืนยันไม่เพิ่ม field ตอน "ได้งาน" นอกเหนือ prototype (modal `#statusUpdateModal` = dead UI ไม่ implement); Entry ที่ราคา/GP เท่ากันติดป้ายพร้อมกันได้ ไม่ต้อง tie-break; scenario ใหม่ D36–D37; **เปิดคำถามใหม่ 1 ข้อยังไม่ปิด (9b.22 — ผูก item master จาก ERP ผู้ใช้ระบุว่าค้างไว้ก่อน)** และตัวเลข man-day ของตาราง PM ในหัวข้อ 10 ต้องทบทวนหลังปิด 9b.22 — **หน้าจออื่นทั้งหมดไม่แตะ เพราะผ่านการ confirm กับผู้ใช้ปลายทางแล้ว**; **รอบ 11 (30 ก.ค. 2026): ตัดขอบเขต AI Chat Assistant ออกทั้งก้อนตามคำสั่งผู้ใช้ (สรุปที่ 0g ใหม่) — 0e ยุบเหลือหมายเหตุ, ถอด 4.5/6.5/A.15/endpoint 26-26b/แถว chat ในหัวข้อ 5/ความเสี่ยง 8.19-8.24 เดิม/คำถาม 9b.16-9b.21/scenario D32-D35/งาน 4 บรรทัดในหัวข้อ 10 ออกทั้งหมด (รายละเอียดเดิมอยู่ใน git commit `748d2bc`), ความเสี่ยงสูงสุดของโครงการ (ข้อมูลต้นทุน/GP ออกไปยัง LLM ภายนอก) และคำถาม blocking เรื่อง LLM provider/DPA หมดไปพร้อมกัน; **เพิ่ม Telegram เป็นช่องทาง push ที่ 2 คู่กับ LINE** — `auth.user` เพิ่ม `telegram_chat_id`/`push_channel_pref`, endpoint 25 เป็น `/notification/push/link` แบบระบุ channel, บังคับทำเป็น channel adapter (0g.3), Telegram ต้องมีขา inbound รับ `/start` ต่างจาก LINE (0g.4), ความเสี่ยงใหม่ 8.19-8.20, คำถามใหม่ 9b.23-9b.25, scenario D31 ปรับเป็น 2 ช่องทาง, ประมาณการ ~95-143 → **~79-119 man-day****
