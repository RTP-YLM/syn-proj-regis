# Flow Project Register — Mermaid (แยกตาม Role)

> แปลงจาก `FlowProjectRegis(Update)_compressed.pdf` (ชุด updated-flow 18 ก.ค. 2026)
> **ปรับตามคำตอบข้อ 9.17–9.21 ที่ปิดครบแล้ว** — จุดที่วาดต่างจาก PDF สรุปไว้ในตารางท้ายไฟล์
>
> ทุกไดอะแกรมแบ่งเลนเป็น 4 role: **Sale** · **หัวหน้าทีม (headsale)** · **Manager / พี่บี (salemanager)** · **CRM (ระบบอัตโนมัติ)**

---

## 1) สร้าง Register / Join Project → นำเสนอ

```mermaid
flowchart TD
    START((Start))

    subgraph SALE["Sale"]
        S1["กดสร้าง Register"]
        S2["ใส่วันคาดจบ"]
        SJ1["เลือก Project เดิมเพื่อ Join"]
        SJ2["สร้าง Entry ใหม่ภายใต้ Project นั้น<br/>(ใช้ ProjectCode เดิม)"]
        S3["กรอกข้อมูล Register"]
        S4["ทำ Project Management"]
        S5["กดบันทึก — Status: บันทึกร่าง (draft)"]
        S6["กดส่งหัวหน้า — Status: รอหัวหน้าอนุมัติ (waiting)"]
        S7["แก้ไขข้อมูลแล้วส่งใหม่"]
    end

    subgraph HEADLANE["หัวหน้าทีม (headsale)"]
        H1{"ตรวจสอบข้อมูล<br/>และอนุมัติ"}
    end

    subgraph MGRLANE["Manager / พี่บี (salemanager)"]
        M1["เมนู ระบุ Leader Project<br/>เลือก 1 Entry เป็น Leader → flag IsLeader<br/>(Entry อื่นคงสถานะเดิม เก็บไว้ compare)"]
    end

    subgraph CRMLANE["CRM (ระบบ)"]
        C2{"เช็คซ้ำ: ชื่อหน่วยงาน /<br/>ชื่อโครงการ / รายการสินค้า"}
        C1["สร้าง Project ใหม่ + ออกเลข ProjectCode<br/>PRJ-YYYY-MM-XXXX<br/>(เลขเดียว ออกตอนสร้าง — ไม่มี SYS No.)"]
        C3["Status: นำเสนอ (presented)"]
        C4["Status: rejected"]
    end

    START --> S1 --> S2 --> C2
    C2 -->|"ไม่ซ้ำ = Project ใหม่"| C1 --> S3
    C2 -->|"ซ้ำ = Join Project เดิม"| SJ1 --> SJ2 --> S3
    S3 --> S4 --> S5 --> S6 --> H1
    H1 -->|"Approve"| C3
    H1 -->|"Reject"| C4 --> S7 --> S6
    C3 -.->|"เฉพาะ Project ที่มีมากกว่า 1 Entry"| M1
```

- อนุมัติ Register ตั้งต้น **ชั้นเดียวที่หัวหน้าทีม** (ข้อ 9.17 — เอาตาม HTML, พี่บีไม่อยู่ในชั้นนี้)
- การระบุ Leader เป็น **flag อย่างเดียว ไม่มีสถานะใหม่** (ข้อ 9.18) — ทำผ่านเมนูของ Manager หลัง Entry เข้าสถานะนำเสนอ

---

## 2) Update Status — เลื่อนวันคาดจบ / แก้ไขข้อมูล (จบที่หัวหน้าทีม ไม่ถึงพี่บี)

```mermaid
flowchart TD
    subgraph SALE["Sale"]
        U0{"เลือกหัวข้อ Update Status"}
        P1["ใส่วันคาดจบใหม่ + เหตุผลที่เลื่อน"]
        E1["ระบุรายละเอียดที่ขอแก้ไข"]
        E3["แก้ไขข้อมูลบน Revision ใหม่"]
        RS["แก้ไขแล้วส่งใหม่ได้"]
    end

    subgraph HEADLANE["หัวหน้าทีม (headsale)"]
        PH{"ตรวจสอบและอนุมัติ"}
        EH{"ตรวจสอบและอนุมัติ"}
    end

    subgraph CRMLANE["CRM (ระบบ)"]
        PR["Status: นำเสนอ (presented)"]
        PC["Update วันคาดจบใหม่<br/>+ เก็บ Log วันคาดจบเดิม"]
        EC["Clone Revision ใหม่<br/>(ของเดิมเก็บเป็น read-only)"]
        RJ1["Status: rejected"]
    end

    PR --> U0
    U0 -->|"3. เลื่อนวันคาดจบ"| P1
    P1 -->|"ส่งอนุมัติ — Status: waitingPostpone"| PH
    PH -->|"Approve"| PC -->|"กลับ Status: นำเสนอ"| PR
    PH -->|"Reject"| RJ1
    U0 -->|"4. แก้ไขข้อมูล Register"| E1
    E1 -->|"ส่งอนุมัติ — Status: waitingEdit"| EH
    EH -->|"Approve"| EC --> E3 -->|"กลับ Status: นำเสนอ"| PR
    EH -->|"Reject"| RJ1
    RJ1 --> RS
```

- ระบบคำนวณ "วันที่เหลือจากวันคาดจบ" ใหม่อัตโนมัติหลัง update วันคาดจบ (ผูกกับไดอะแกรมข้อ 4)

---

## 3) Update Status — ได้งาน / ไม่ได้งาน (แพ้ · ล่ม) → End

```mermaid
flowchart TD
    subgraph SALE["Sale"]
        U0{"เลือกหัวข้อ Update Status"}
        W1["ใส่ข้อมูล Bid Result"]
        L0{"เลือก แพ้ หรือ ล่ม"}
        L1["แพ้ (lose):<br/>เหตุผลที่ไม่ได้งาน + ข้อมูล Bid Result"]
        L2["ล่ม (collapse):<br/>สาเหตุ + วันที่ปิดโครงการ + รายละเอียด"]
        RS["แก้ไขแล้วส่งใหม่ได้"]
    end

    subgraph HEADLANE["หัวหน้าทีม (headsale)"]
        WH{"ตรวจสอบและอนุมัติ"}
        LH{"ตรวจสอบและอนุมัติ"}
    end

    subgraph MGRLANE["Manager / พี่บี (salemanager)"]
        WM{"ตรวจสอบและอนุมัติ"}
        LM{"ตรวจสอบและอนุมัติ"}
    end

    subgraph CRMLANE["CRM (ระบบ)"]
        PR["Status: นำเสนอ (presented)"]
        WS["Status: ได้งาน (won)"]
        LS["Status: ไม่ได้งาน (lost)"]
        CS["Status: ปิดโครงการ (closed)<br/>มีผลทันที ไม่ผ่านการอนุมัติ<br/>+ แจ้งหัวหน้าทีม/Manager รับทราบ"]
        RJ["Status: rejected"]
    end

    FIN((End))

    PR --> U0
    U0 -->|"1. ได้งาน"| W1
    W1 -->|"ส่งอนุมัติ — Status: waitingWon"| WH
    WH -->|"Approve — Status: waitingSupervisorWon"| WM
    WM -->|"Approve"| WS --> FIN
    WH -->|"Reject"| RJ
    WM -->|"Reject"| RJ
    U0 -->|"2. ไม่ได้งาน"| L0
    L0 -->|"แพ้"| L1
    L1 -->|"ส่งอนุมัติ — Status: waitingLost"| LH
    LH -->|"Approve — Status: waitingSupervisorLost"| LM
    LM -->|"Approve"| LS --> FIN
    LH -->|"Reject"| RJ
    LM -->|"Reject"| RJ
    L0 -->|"ล่ม"| L2 --> CS --> FIN
    RJ --> RS
```

- พี่บีอนุมัติ**เฉพาะชั้นที่ 2 ของ ได้งาน / แพ้** เท่านั้น (`waitingSupervisorWon/Lost → won/lost`)
- **ล่ม = End ทันที** ไม่มีขั้นอนุมัติ — mitigate ด้วย required fields + log + แจ้งเตือนหัวหน้า/Manager (ความเสี่ยงข้อ 8.9 ในเอกสาร impact)

---

## 4) แจ้งเตือนใกล้ครบกำหนด (เหลือน้อยกว่า 90 วันจากวันคาดจบ)

```mermaid
flowchart LR
    subgraph CRMLANE["CRM (ระบบ)"]
        T["คำนวณวันที่เหลือ<br/>จากวันคาดจบ (อัตโนมัติ)"]
        D{"เหลือน้อยกว่า 90 วัน?<br/>(เกณฑ์วันตั้งค่าได้โดย admin)"}
        N["สร้างการแจ้งเตือน"]
        X["ไม่แจ้งเตือน"]
    end

    subgraph SALE["Sale"]
        NS["Alert เฉพาะงานของตัวเอง"]
    end

    subgraph HEADLANE["หัวหน้าทีม (headsale)"]
        NH["Alert งานของลูกทีม<br/>(ตาม matrix ทีม TMTeamUser)"]
    end

    subgraph MGRLANE["Manager / พี่บี (salemanager)"]
        NM["Alert ทุก Project ในระบบ"]
    end

    T --> D
    D -->|"ใช่ และสถานะไม่ใช่<br/>won / lost / closed"| N
    D -->|"ไม่ใช่ หรือเป็นสถานะปลายทางแล้ว"| X
    N --> NS
    N --> NH
    N --> NM
```

---

## จุดที่วาดต่างจาก PDF (ตามคำตอบที่ปิดแล้ว 18 ก.ค. 2026)

| # | ใน PDF | ใน Mermaid ชุดนี้ | อ้างอิง |
|---|--------|-------------------|---------|
| 1 | ออกเลข 2 ชุด: SYS No. ตอนสร้าง + Project ID หลังอนุมัติ | เลขเดียว `ProjectCode PRJ-YYYY-MM-XXXX` ออกตอนสร้าง Project ใหม่ (Join ใช้เลขเดิม) | ข้อ 9.19 — SYS No. เป็นเลขอีกระบบ ยังไม่ทำ |
| 2 | Register ตั้งต้นอนุมัติ 2 ชั้น (หัวหน้าทีม → พี่บี) | ชั้นเดียวที่หัวหน้าทีม `waiting → presented` | ข้อ 9.17 — เอาตาม HTML |
| 3 | สถานะ "รอ Manager ระบุ Leader" + Entry อื่นเป็น "ยกเลิก" | ไม่มีสถานะใหม่ — flag `IsLeader` ที่ Entry เดียว, Entry อื่นคงสถานะเดิม | ข้อ 9.18 |
| 4 | แจ้งเตือนยกเว้นเฉพาะ "ไม่ได้งาน, ยกเลิก" | ยกเว้นสถานะปลายทางทั้งหมด `won / lost / closed` | ข้อ 9.21 — won ไม่ต้องแจ้ง |
| 5 | Reject วนกลับไปแก้ที่ step เดิมโดยตรง | Reject → Status `rejected` แล้ว Sale แก้ไข/ส่งใหม่ | ตาม Prototype (ข้อ 9.1) |
| 6 | ไม่มี branch "แก้ไขข้อมูล Register" | เพิ่มตาม HTML: `waitingEdit` → clone Revision ใหม่ | ข้อ 9.6 (Revision) |

สถานะที่ใช้ทั้งหมด 13 ตัว (เท่าเดิม ไม่มีเพิ่ม): `draft, waiting, presented, rejected, waitingWon, waitingSupervisorWon, won, waitingLost, waitingSupervisorLost, lost, waitingPostpone, waitingEdit, closed`

รายละเอียดฉบับเต็ม: `docs/impact-assessment-project-register.md`
