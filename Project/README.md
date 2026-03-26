## 🧠 Database Design

The system includes the following core entities:

- **Content** (Movies, TV Shows)
- **User**
- **Subscription_Plan**
- **Watchlist**
- **Review**
- **Actor / Director**
- **Genre / Country**
- **Transaction**

### 🔗 Key Relationships
- Many-to-Many: Content ↔ Actor, Content ↔ Genre
- One-to-Many: User → Review, User → Watchlist
- One-to-One: User ↔ Subscription

The database is normalized up to **3NF** to reduce redundancy and ensure data integrity.

---

## ⚙️ Features Implemented

### 🔁 Triggers
- Limit watchlist to 50 items
- Auto-archive low-rated content
- Prevent duplicate director assignments

### 📊 Functions
- Top genres by watch hours
- Most frequent actor-director collaborations
- Validate user subscription status

### 📦 Procedures
- Monthly user activity report
- Batch content updates
- Failed payment handling

### ⏱️ Events
- Remove expired subscriptions automatically
- Refresh daily content rankings

---

## 📥 Data Ingestion (Python)

A Python script reads and processes raw CSV data and inserts it into the database.

### ▶️ How to Run
```bash
pip install mysql-connector-python
python ReadData.py