# 🛒 Online Retail Database (MySQL)

A relational database project simulating an **online retail store**, built in MySQL. It covers schema design, sample data, 20+ analytical queries, performance indexing, views, and audit-log triggers — designed as a hands-on demonstration of core to advanced SQL concepts.

---

## 📌 Project Overview

| | |
|---|---|
| **Database Name** | `OnlineRetailDB` |
| **Engine** | MySQL |
| **Tables** | 6 (`Customers`, `Products`, `Categories`, `Orders`, `OrderItems`, `Changelog`) |
| **Views** | 3 |
| **Triggers** | 5 (audit logging) |
| **Indexes** | 8 (performance optimization) |
| **Analytical Queries** | 20+ |

---

## 🗂️ Schema Design

```
Categories ──┐
             │ (1:N)
             ▼
         Products ──┐
                     │ (1:N)
                     ▼
Customers ──┐    OrderItems
            │ (1:N) ▲
            ▼        │ (1:N)
          Orders ────┘
```

### Table Structure

**Customers**
| Column | Type |
|---|---|
| CustomerID | INT, PK, AUTO_INCREMENT |
| FirstName / LastName | VARCHAR(50) |
| Email, Phone, Address, City, State, ZipCode, Country | VARCHAR |
| CreatedAt | DATETIME (default NOW()) |

**Products**
| Column | Type |
|---|---|
| ProductID | INT, PK, AUTO_INCREMENT |
| ProductName | VARCHAR(100) |
| CategoryID | INT (FK → Categories) |
| Price | DECIMAL(10,2) |
| Stock | INT |
| CreatedAt | DATETIME |

**Categories**
| Column | Type |
|---|---|
| CategoryID | INT, PK, AUTO_INCREMENT |
| CategoryName | VARCHAR(100) |
| Description | VARCHAR(255) |

**Orders**
| Column | Type |
|---|---|
| OrderID | INT, PK, AUTO_INCREMENT |
| CustomerID | INT (FK → Customers) |
| OrderDate | DATETIME |
| TotalAmount | DECIMAL(10,2) |

**OrderItems**
| Column | Type |
|---|---|
| OrderItemID | INT, PK, AUTO_INCREMENT |
| OrderID | INT (FK → Orders) |
| ProductID | INT (FK → Products) |
| Quantity | INT |
| Price | DECIMAL(10,2) |

**Changelog** *(audit table)*
| Column | Type |
|---|---|
| LogID | INT, PK, AUTO_INCREMENT |
| TableName | VARCHAR(50) |
| Operation | VARCHAR(20) |
| RecordID | INT |
| ChangeDate | DATETIME |
| ChangedBy | VARCHAR(50) |

---

## 🌱 Sample Data

The script seeds the database with realistic sample records:
- **3 categories** — Electronics, Clothing, Books
- **9 products** across those categories (including an out-of-stock item)
- **7 customers** from the USA and India
- **3 orders** with corresponding **order items**

---

## 🔍 Analytical Queries (20+)

The project includes a progressive set of business-intelligence queries, covering:

| # | Query |
|---|---|
| 1 | Orders for a specific customer |
| 2 | Total sales per product |
| 3 | Average order value |
| 4 | Top 5 customers by spending |
| 5 | Most popular product category |
| 6 | Out-of-stock products |
| 7 | Customers who ordered in the last 30 days |
| 8 | Monthly order counts |
| 9 | Most recent order details |
| 10 | Average product price per category |
| 11 | Customers who never placed an order |
| 12 | Total quantity sold per product |
| 13 | Total revenue per category |
| 14 | Highest-priced product per category |
| 15 | Orders above a specific total |
| 16 | Products ranked by order frequency |
| 17 | Top 3 most frequently ordered products |
| 18 | Customer count by country |
| 19 | Total spending per customer |
| 20 | Orders with more than one item |

---

## 🧾 Audit Logging (Triggers)

To track data changes, a **Changelog** table records every insert, update, and delete on key tables via `AFTER` triggers:

| Table | Trigger | Event |
|---|---|---|
| Products | `trg_Insert_Product` | AFTER INSERT |
| Products | `trg_Update_Product` | AFTER UPDATE |
| Products | `trg_Delete_Product` | AFTER DELETE |
| Customers | `trg_Insert_Customers` | AFTER INSERT |
| Customers | `trg_Update_Customers` | AFTER UPDATE |
| Customers | `trg_Delete_Customers` | AFTER DELETE |

Each trigger logs the affected `TableName`, `Operation`, `RecordID`, timestamp, and the executing MySQL user.

---

## ⚡ Performance Optimization — Indexing

Non-clustered indexes were added to speed up frequent filter/sort operations:

| Table | Index | Column(s) |
|---|---|---|
| Products | `IDX_Products_CategoryID` | CategoryID |
| Products | `IDX_Products_Price` | Price (DESC) |
| Orders | `IDX_Orders_CustomerID` | CustomerID |
| Orders | `IDX_Orders_OrderDate` | OrderDate |
| OrderItems | `IDX_OrderItems_OrderID` | OrderID |
| OrderItems | `IDX_OrderItems_ProductID` | ProductID |
| Customers | `IDX_Customers_Email` | Email |
| Customers | `IDX_Customers_Country` | Country |

---

## 👁️ Views

Reusable virtual tables that simplify recurring queries:

| View | Purpose |
|---|---|
| `vw_productdetails` | Product info joined with category name |
| `vw_OrderSummary` | Per-customer order count & total amount spent |
| `vw_RecentOrders` | Orders placed in the last 30 days |

Sample use-cases built on top of these views include filtering by price range, counting products per category, and finding high-value recent orders.

---

## 🛠️ Tech Stack

- **Database:** MySQL
- **Concepts used:** DDL/DML, Joins, Aggregations, Subqueries, Window Functions (`ROW_NUMBER`), Views, Triggers, Indexing

---

## 📈 Possible Extensions

- Complete the remaining stubbed queries (Query 37–44) using the views
- Add stored procedures for common report generation
- Connect to a BI tool (Power BI / Tableau) for dashboarding
- Add a low-stock alert query/view (threshold-based)

---

## 👤 Author

**Roshan Kumar**
Final-year B.Tech (Mechanical Engineering), MANIT Bhopal

---

## 🙏 Acknowledgements

This project was built while following a tutorial by **Ishwer Academy** on YouTube, and extended/practiced independently for learning purposes.
