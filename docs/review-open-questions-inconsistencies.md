# Review — คำถามที่ยังรอคำตอบ + ความไม่สอดคล้องของ Impact / Design

> อ่านเมื่อ: 2 ส.ค. 2026 · เอกสารที่ตรวจ: `docs/impact-assessment-project-register.md` (รอบ 11, 30 ก.ค. 2026) + `openspec/changes/add-project-register/*` (design.md, proposal.md, tasks.md, screens.md, specs/*) + `contract-reconciliation.md` (superseded)
>
> สรุปสั้น: **คำถาม business ปิดครบแล้ว (24 ข้อ) — คำถามที่ค้างทั้งหมดเป็นเรื่อง stack/infra/ช่องทาง push (9b) จำนวน 16 ข้อ** และพบ **จุดที่ข้อมูลไม่สอดคล้องกัน 12 จุด** (B1–B4, C1–C3, D1–D5) ที่ใหญ่สุดคือ design.md อ้างถึง decision D12/D13/D14 ซึ่ง**ไม่เคยถูกเขียนไว้ในหัวข้อ Decisions ของ design.md เลย** (มีแค่ D1–D11)

> ### ✅ สถานะการแก้ (2 ส.ค. 2026)
> ความไม่สอดคล้องทั้ง **12 จุด (B1–B4, C1–C3, D1–D5) แก้ครบแล้ว** — รายละเอียดสิ่งที่ทำในแต่ละจุดอยู่ท้ายเอกสาร (§สรุปภาพรวม)
> คำถามค้าง 16 ข้อในส่วน A **ยังเปิดอยู่ตามเดิม** — ต้องรอผู้ใช้/ทีมตอบ

---

## ส่วน A — คำถามที่ยังรอคำตอบ (รอผู้ใช้/ทีมตัดสินใจ)

### A.1 Blocking ก่อนเริ่ม implement จริง (ยืนยันจาก impact §0g.5, design D11)

| # | คำถาม | ผลกระทบ |
|---|---|---|
| 9b.4 | **ORM/query layer** (Prisma / Drizzle / Knex+pg) | รูปแบบ migration script (A.14) + โครงสร้าง service layer |
| 9b.7 | **Design system/component library** ฝั่ง React (MUI / Ant / Chakra / Tailwind) | เวลาออกแบบ UI + งาน "design system จาก 0" ในประมาณการ |

### A.2 ปิดก่อนเริ่มงานก้อน Responsive + LINE/Telegram (เปิดค้างครบ 8 ข้อ ยังไม่ปิดสักข้อ — impact §10 ลำดับงานข้อ 6)

| # | คำถาม |
|---|---|
| 9b.11 | Responsive breakpoint + pattern แสดงผลตาราง PM (18 คอลัมน์) / ตารางเปรียบเทียบบนมือถือ — **ยังไม่มี mockup** (เสี่ยง 8.15 สูงสุดของ UI) |
| 9b.12 | ใช้ LINE OA ตัวไหน — ของเดิมในองค์กร หรือสร้างใหม่เฉพาะระบบนี้ |
| 9b.13 | วิธีผูกบัญชี LINE ↔ ผู้ใช้ (LINE Login OAuth / รหัสยืนยันในแชท / admin กรอก userId) |
| 9b.14 | LINE push ทางเดียว หรือให้กดอนุมัติใน Flex Message ได้ (ต้องมี webhook รับ postback) |
| 9b.15 | เหตุการณ์ไหนบ้างที่ push (เฉพาะรออนุมัติ / รวม approved/rejected/won/lost/ล่ม) — ผูกกับโควตา LINE (เสี่ยง 8.16) |
| 9b.23 | ใช้ Telegram bot ตัวไหน + **องค์กรอนุญาตให้ใช้ Telegram เป็นช่องทางงานจริงหรือไม่** |
| 9b.24 | รับ `/start` ด้วย webhook (ต้องเปิด inbound) หรือ long-polling — ต่างจาก LINE ที่ push ทางเดียว |
| 9b.25 | ผู้ใช้ 1 คน ผูกได้ 2 ช่องทางพร้อมกันหรือไม่ + ใครเป็นคนตั้ง (`push_channel_pref`) |

### A.3 เปิดค้าง แต่ไม่ปิดก่อนเริ่มก็ทำต่อได้

| # | คำถาม | สมมติฐานปัจจุบันที่เอกสารใช้เขียนต่อ |
|---|---|---|
| 9b.5 | ที่เก็บไฟล์แนบ (disk vs object storage) | แนะนำ object storage (S3-compatible) ยังไม่ฟันธง |
| 9b.6 | Repo topology + ชื่อ repo (mono vs แยก UI/API) | เขียนเป็น "UI"/"API" เฉยๆ |
| 9b.8 | แหล่งข้อมูลภูมิศาสตร์ไทย | seed จาก dataset เปิดสาธารณะ |
| 9b.9 | Hosting/deployment + CI/CD | ยังไม่ระบุ — กระทบ redirect_uri ของ SSO ด้วย |
| 9b.10 | ต้อง migrate ข้อมูลจากระบบเดิมไหม (user/Dealer) หรือเริ่มว่างเปล่า | สมมติเริ่มว่างเปล่า — ถ้าต้อง migrate = งานใหม่ทั้งก้อนที่ยังไม่ได้ประเมิน |
| 9b.22 | **ผูกช่อง รายการ/Model ของตาราง PM กับ item master ของ ERP** (API / sync / พิมพ์เอง) | รอบแรกกรอกเอง + เตรียม `erp_item_code` ไว้ — กระทบตัวเลข man-day ของตาราง PM + กระทบกติกา `cost_quote_date` |

### A.4 สมมติฐานที่ impact เองระบุว่า "ยังไม่ยืนยัน — เปลี่ยนได้ก่อนเริ่ม implement"

- **GP ตัวหลักนอกหน้า PM** (หน้าเปรียบเทียบ / ป้าย "GP สูงสุด/ดีที่สุด" / รายงาน) ใช้ `gp_after_oc` — impact A.8.3.1 บอกชัดว่า "สมมติฐานที่ใช้ต่อ (ยังไม่ยืนยัน)" แต่ spec `project-entry-comparison` เขียนเป็น "SHALL be the GP-after-OC figure" (ดู จุดไม่สอดคล้อง #9)
- 1.5 (project-lifecycle): "server ปฏิเสธคำขอเปลี่ยนสถานะใหม่ของ Entry ที่เหลือ + หยุดแจ้งเตือน near-due ทั้ง Project" — impact เขียนว่า "ยืนยันรายละเอียดอีกครั้งตอน spec ได้" (design D2 ตัดสินไว้แล้ว ยังไม่กลับไปลบคำว่า "รอยืนยัน")
- 4.2.2: ชื่อทีม 10 ทีม / sale1–sale20 / ยี่ห้อคู่แข่ง / ประเภทหน่วยงาน เป็น master data จาก API (seed) — แหล่งข้อมูลจริงยังไม่ยืนยัน
- A.8.4 ข้อ 8: ช่องต้นทุน @ ต้องรองรับพิมพ์นิพจน์คูณ/บวก (`=294.893*3`) หรือมีช่อง qty×unit ย่อย — **ยังไม่ตัดสินใจ (ไม่ blocking)**
- 8.12: ความคุ้นเคย stack ใหม่ของทีม (React/Node/Postgres) "ยังไม่ทราบ ต้องยืนยันจากผู้ใช้" — กระทบประมาณการรวมโดยตรง (ไม่รวม ramp-up อยู่แล้ว ~79–119 md)

### A.5 งานที่ต้องประสานกับทีมภายนอก (ไม่ใช่คำถาม internal)

- ทีม SSO: ลงทะเบียนแอป (client_id/secret, redirect_uri) + ตั้ง `group_role_map` ครบ 4 role + ขอ `public.pem` + ช่องทางแจ้ง rotate key (impact §9c)
- LINE: ต้องยืนยันแพ็กเกจ/โควตา OA (เสี่ยง 8.16)
- **กลไกเปิด/ปิดเมนูจาก DB ยังไม่ได้ออกแบบ** (project.md §Architecture Patterns) — ไม่บังคับ แต่ถ้าต้องการต้องออกแบบใหม่

---

## ส่วน B — ความไม่สอดคล้องภายใน impact assessment เอง

| # | จุด | ปัญหา |
|---|---|---|
| B1 | **§10 แถว "ทดสอบรวม + แก้บั๊ก + UAT"** | ยังเขียน "…responsive/LINE — D30–D31 **+ AI chat — D32–D35**" ค้างอยู่ ทั้งที่ 0g (รอบ 11) ตัด chat ออกแล้ว — scenario D32–D35 ถูกลบออกจากภาคผนวก D แล้ว แต่แถวประมาณการยังอ้างถึง |
| B2 | **§10 หัวข้อ** | ขึ้นต้นด้วย "⚠️ ตัวเลขเดิมก่อน re-platform…ต้องประเมินใหม่" แต่ตัวรวมท้ายตาราง (~79–119 md) เป็นตัวเลขที่ผ่านการปรับรอบ 5–11 แล้ว — คำเตือนค้างจากรอบเก่า หลงเหลือให้เข้าใจผิดว่ายังไม่มีการประเมินใหม่ |
| B3 | **§3 "สิ่งที่ต้องตัดสินใจก่อนเริ่ม coding จริง (blocking)"** | ระบุ 4 รายการ: ORM + ที่เก็บไฟล์แนบ + responsive pattern + LINE OA/Telegram bot/วิธีผูกบัญชี — แต่ §10 ลำดับงานข้อ 0 และ 0g.5/D11 บอกว่า blocking เหลือแค่ **ORM + design system** — คำว่า "blocking" ใช้ไม่ตรงกันระหว่าง §3 (เขียน 21–22 ก.ค.) กับ 0g/§10 (เขียนทีหลัง) |
| B4 | **§10 หัวข้อ ยังอ้าง "คำถาม business ปิดครบ 24 ข้อ"** | ถูกต้อง แต่แถว "เขียน spec/API contract" เขียนว่า "เหลือคำถาม stack 9b บางส่วน: ORM/design system/repo topology ฯลฯ" — repo topology (9b.6) จริงๆ ไม่ blocking (A.3) นอกนั้นโอเค — เป็นความต่างระดับ "blocking vs non-blocking" ที่ควรทำให้เป็นชุดเดียวกัน |

---

## ส่วน C — Impact ↔ OpenSpec design/spec ไม่ตรงกัน

| # | จุด | Impact บอก | design/spec บอก | ผล |
|---|---|---|---|---|
| C1 | **GP ตัวหลักนอกหน้า PM** | A.8.3.1: "สมมติฐานยังไม่ยืนยัน — ใช้ `gp_after_oc` เป็นค่าหลัก ถ้าจะใช้ `gp_before_oc` ให้แจ้งก่อนเริ่ม" | `project-entry-comparison` R: "The GP shown **SHALL** be the GP-after-OC figure" | Spec เขียนเป็นข้อกำหนดบังคับทั้งที่ impact ยัง mark ว่าเป็นสมมติฐานรอ confirm — ถ้า user เลือก gp_before_oc ทีหลัง spec ต้องแก้ |
| C2 | **จำนวน acceptance scenario** | ภาคผนวก D ปัจจุบันมี **33 ข้อ** (D1–D31 + D36–D37 หลังตัด D32–D35) | design.md Context: "…and **35 acceptance scenarios**…" | ตัวเลขค้างจากก่อนตัด chat (35 = 31+4 chat เดิม… ปัจจุบันเป็น 33) |
| C3 | **ขอบเขต D32–D35 ใน tasks.md** | 0g: scenario D32–D35 ถูกลบแล้ว | tasks.md 7.2: "Walk every scenario in … Appendix D (**D1–D37**, including…)" | อ้างช่วง D1–D37 ซึ่ง D32–D35 ไม่มีอยู่จริง — ควรเป็น "D1–D31, D36–D37" |

---

## ส่วน D — ภายใน OpenSpec เอง (จุดไม่สอดคล้องที่สำคัญที่สุด)

| # | จุด | ปัญหา |
|---|---|---|
| D1 | **design.md อ้าง D12/D13/D14 แต่ไม่เคยนิยาม** — หัวข้อ Decisions มีแค่ **D1–D11** แต่ references ทั้งหมดนี้ชี้ไปหา decision ที่ไม่มีอยู่จริง: |
| | • tasks.md 1.1/1.4/2.3b/3.4b/7.2b → "(D12)", 1.2/2.3 → "(D13)", 1.2b/2.6b/3.5b → "(D14)" | |
| | • design.md ตัวเอง: Data Model Summary (`entry_task` (D12), `ep_item_type` (D12), `registration_revision` (D14)), Risks (D12, D14), Open Questions ("erp_item_code column reserved (D12)") | |
| | • proposal.md: "design D12", "design D13", "design D14" | |
| | • screens.md S5: "design D12" | |
| | → **decision D12 (ตาราง PM ตาม Template Excel), D13 (duplicate-check = org+project เท่านั้น), D14 (Project-level revision) ถูกตัดสินจริงใน impact 0f (27 ก.ค.) แต่ไม่เคยถูกเขียนลง design.md เป็นหัวข้อ Decisions** — ใครอ่าน design.md เพื่อหา "why" จะหาไม่เจอ ควรเพิ่มหัวข้อ D12/D13/D14 ให้ครบ (เนื้อหามีอยู่ใน impact 0f/A.4b/A.8 แล้ว) |
| D2 | **design.md Context (บรรทัดแรก)** ยังเล่า AI Chat Assistant เป็น "an added scope for an AI Chat Assistant…" ในลักษณะที่เป็น scope ปัจจุบัน | แม้ Non-Goals/D11 จะบอกว่าตัดแล้ว แต่ย่อหน้า Context (รวม "35 acceptance scenarios") ยังไม่ได้ปรับตามรอบ 11 — อ่านรวดเดียวจะสับสนว่ายังอยู่ใน scope |
| D3 | **design.md D9 เขียน "PM task tree, up to 3 levels deep"** | เทียบ A.8.4/0f: ระดับ record จริง = **2 ระดับ (main → spec) + แถวสรุปที่คำนวณตอนแสดงผล** — prototype เก่ารองรับ 3 ระดับ แต่ template ตัดเหลือ 2 — คำว่า "up to 3 levels deep" เป็นของค้างจากก่อน 0f (minor — screens.md บอก 3 ชั้นนับรวมแถวสรุป ซึ่งก็โอเค แต่ D9 ควรพิมพ์ให้ตรงกับ template) |
| D4 | **tasks.md 2.10 "all endpoints from design.md's data model / the impact assessment's API contract appendix"** | design.md ไม่มีรายการ endpoint (ไม่มี API contract ใน design.md) — ต้องไปเปิด impact ภาคผนวก B เอาเอง — ไม่ใช่ความผิด แต่ design.md ควรลิงก์ชัดๆ (ตอนนี้ลิงก์แค่ "data model") |
| D5 | **`contract-reconciliation.md`** | ระบุ SUPERSEDED ไว้ถูกต้องแล้ว (21 ก.ค.) — แต่ยังอยู่ใน `changes/add-project-register/` ทำให้ `openspec`/คนอ่านคิดว่านี่คือ contract ที่ apply อยู่ — แนะนำย้ายไป `changes/archive/` เพื่อไม่ให้เข้าใจผิด |

---

## สรุปภาพรวม

- **รอคำตอบ: 16 คำถาม (9b)** — blocking จริง 2 (ORM 9b.4, design system 9b.7) · ก้อน mobile+push 8 ข้อยังเปิดค้าง 0/8 · ที่เหลือ 6 ข้อไม่ blocking แต่ 9b.22 (ERP item) กระทบตัวเลข man-day
- **ไม่สอดคล้อง: 12 จุด** (B1–B4 ใน impact, C1–C3 ข้ามเอกสาร, D1–D5 ใน openspec) — ตัวหลักคือ **D12/D13/D14 หายไปจาก design.md** และ **การตัดสินใจรอบ 11 (ตัด chat) ยังไล่ลบไม่ครบ** (B1, C2, C3, D2)

### ✅ สิ่งที่แก้ไปแล้ว (2 ส.ค. 2026)

| จุด | สิ่งที่ทำ |
|---|---|
| **D1** | เพิ่มหัวข้อ **D12 / D13 / D14** เข้า design.md Decisions ครบ (D12 = ตาราง PM ตาม Template Excel: 2 ระดับ + แถวสรุป computed + GP 2 ชุดตามกติกา OC, D13 = identity/duplicate-check = org+project เท่านั้น Dealer อยู่ระดับ Entry, D14 = Project-level revision + 3 กติกา re-check ตอน approve) — เนื้อหาดึงจาก impact 0f/A.4b/A.8 |
| **D2, C2** | design.md Context เขียนใหม่: AI Chat เปลี่ยนจาก "added scope" เป็นบันทึกการตัดออกรอบ 11, เพิ่มรอบ 0f (D12–D14), แก้ "35 acceptance scenarios" → **33 (D1–D31, D36–D37)** |
| **C3** | tasks.md 7.2 → `D1–D31 and D36–D37 — 33 scenarios` พร้อมหมายเหตุว่า D32–D35 ถูกลบตาม 0g |
| **B1** | impact §10 แถว UAT ลบ `+ AI chat — D32–D35` → เหลือ `responsive/LINE + Telegram — D30–D31` |
| **B2** | impact §10 หัวข้อ + คำเตือน เขียนใหม่: ระบุชัดว่ายอดรวม ~79–119 md **ผ่านการปรับรอบ 5–11 แล้ว** ไม่ใช่ตัวเลขค้างจากยุค .NET (แยกจากตัวเลขรายบรรทัดที่ยังเป็นสัดส่วนเดิม) |
| **B3** | impact §3 แยก blocking เป็น 2 ระดับให้ตรงกับ 0g.5/§10: blocking ก่อนเขียนโค้ด 2 ข้อ (ORM 9b.4, design system 9b.7) vs blocking เฉพาะก้อนงานตัวเอง (9b.5, 9b.11–9b.15, 9b.23–9b.25) |
| **B4** | impact §10 แถว "เขียน spec/API contract" → ระบุ blocking 2 ข้อ + หมายเหตุว่า repo topology (9b.6) ไม่ blocking |
| **C1** | ✅ **ผู้ใช้ฟันธง 2 ส.ค. 2026: ใช้ `gp_after_oc` เป็น GP หลักนอกหน้า PM** — impact A.8.3.1 เปลี่ยนจาก "สมมติฐาน ยังไม่ยืนยัน" เป็นข้อสรุปที่ปิดแล้ว ตรงกับ spec ที่เขียน SHALL ไว้ |
| **D3** | design.md D9 แก้ "PM task tree, up to 3 levels deep" → "2 record levels + display-only summary row, 18 columns (D12)" |
| **D4** | tasks.md 2.10 ชี้ endpoint ไปที่ **impact ภาคผนวก B** ตรงๆ + ระบุว่า design.md มีแค่ data model |
| **D5** | ✅ ย้าย `contract-reconciliation.md` → **`docs/archive/`** (ออกจากโฟลเดอร์ change แล้ว ไม่มี reference ค้าง) |
| — | แก้ตัวเลขที่เอกสารรีวิวนี้นับผิดเอง: หัวสรุป 9 → 12 จุด, ก้อน mobile+push 9 → **8 ข้อ** (9b.11–15 + 9b.23–25) |

`openspec validate add-project-register --strict` → ✅ valid

### เหลือทำ (ต้องรอคำตอบผู้ใช้/ทีม)
1. ปิดคำถาม blocking 2 ข้อ: ORM (9b.4) + design system (9b.7) — ก่อนเขียนโค้ดบรรทัดแรก
2. ปิดคำถาม 9b.11–9b.15 + 9b.23–9b.25 (8 ข้อ) ก่อนเริ่มงาน responsive/push จริง
3. ปิด 9b.22 (ERP item master) เพื่อ finalize ตัวเลข man-day ของตาราง PM
