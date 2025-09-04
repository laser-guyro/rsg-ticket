# RSG Ticket — Roleplay Server Ticket System

A lightweight, real-time ticketing system built specifically for roleplay servers where players need help from staff.

## ✨ Overview
The system is split into **two parts**:

- **Player side** — Players run `/ticket` to create a ticket and provide relevant details for admins.
- **Admin side** — Admins run `/tickets` to open the ticket center: a rich list of open tickets where they can read the content and **claim** a ticket.

## 🧭 How it works

### Player Flow
1. Player types **`/ticket`**.  
2. A form opens where they describe the issue (the more relevant details, the better).  
3. The player is notified **in real time** when an admin claims their ticket.

### Admin Flow
1. Admin types **`/tickets`** to access the ticket center.  
2. They see a **full list of open tickets**, can read each ticket’s content, and **claim** one.  
3. When a ticket is claimed:
   - The admin is **teleported directly to the player** who opened it.  
   - If the player is **offline**, the admin is notified, and the ticket **disappears automatically** from the list.

### Persistence & Notifications
- Tickets **remain in the list until they are claimed**, even **after a server restart**.  
- **Real-time notifications**:
  - Players are notified when their ticket is claimed.
  - Admins are notified when a new ticket is created.

## 📊 Stats (last 30 days)
Built-in statistics let you see **how many tickets each admin has claimed** over the **last 30 days**.

## 🛠️ Essential Setup

1. **Database**
   - Add/import the two tables into your database:  
     - `tickets`  
     - `ticket_stats`

2. **Commands**
   - Player: **`/ticket`** — open the ticket form  
   - Admin: **`/tickets`** — open the ticket center

3. **Configuration (`config.lua`)**
   Add your admin licenses:

```lua
-- Admins who can claim tickets and access /tickets
AdminIDs = {
  -- "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
}

-- Admins who can view the ticket stats dashboard
StatAdminLicences = {
  -- "license:yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
}
```

> **Note**  
> - `AdminIDs` → grants access to claim tickets and use `/tickets`  
> - `StatAdminLicences` → grants access to view the claimed-ticket statistics

## ✅ Features at a glance
- `/ticket` for players, `/tickets` for admins
- Detailed, scrollable ticket list for staff
- One-click **claim** with **auto-teleport** to the player
- **Offline player** detection with auto-removal from the list
- **Real-time** notifications for both admins and players
- Tickets **persist through restarts**
- **30-day** admin claim statistics

## 📦 Installation (quick)
1. Import the provided SQL for `tickets` and `ticket_stats` into your database.
2. Place the resource in your server resources folder.
3. Add your admin licenses to `config.lua` as shown above.
4. Start the resource and test with `/ticket` and `/tickets`.

## 🗂️ Folder Structure (suggested)
```
rsg-ticket/
├─ client/
├─ server/
├─ config.lua
├─ sql/
│  ├─ tickets.sql
│  └─ ticket_stats.sql
└─ README.md
```
<img width="1429" height="920" alt="Screenshot 2025-09-05 011555" src="https://github.com/user-attachments/assets/0fdefba7-745e-4464-9cd8-d1605bdeff97" />
<img width="1369" height="857" alt="Screenshot 2025-09-05 011906" src="https://github.com/user-attachments/assets/ab2126d9-4331-4764-9417-fe01773e8cb8" />



## 🤝 Contributing
Issues and PRs are welcome! If you’ve got ideas for improvements or found a bug, open an issue.

## 📜 License
Add your preferred license here (e.g., MIT).

---

**RSG Ticket** — built for staff speed, player clarity, and smooth roleplay support.
