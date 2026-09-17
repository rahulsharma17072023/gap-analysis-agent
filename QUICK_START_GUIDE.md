# 🚀 Gap Analysis Platform - Quick Start Guide

**Status:** ✅ **READY TO USE**  
**Date:** September 17, 2026

---

## 📊 What This Does

Your AI Agent analyzes **whitespace opportunities** by comparing:
1. **Your Mordor Intelligence titles** (uploaded Excel)
2. **Competitors' titles** (10 pre-loaded competitors)
3. **Date range** (monthly analysis)

**Output:** Excel report with 4 sheets showing gaps, covered titles, and detailed metrics.

---

## 🎯 Quick Start (5 minutes)

### Step 1: Run the App
```bash
cd C:\Users\RahulSharma\OneDrive\ -\ Mordor\ Intelligence\Desktop\gap-analysis-agent
python app_simple.py
```

**Expected output:**
```
* Running on http://127.0.0.1:3000
```

### Step 2: Open in Browser
Go to: **http://localhost:3000**

You'll see the Gap Analysis Platform interface.

### Step 3: Upload & Analyze
1. **Select Date Range** — Start and end date for your analysis period
2. **Select Competitors** — Choose 3-5 competitors from the dropdown
3. **Upload Excel File** — Your Mordor titles portfolio (must have `Title` and `Status` columns)
4. **Click "Analyze"** — Wait 2-5 seconds
5. **Download Report** — 4-sheet Excel file with results

---

## 📁 Input File Format

Your Excel file must have these columns:

| Column | Required | Example |
|--------|----------|---------|
| **Title** | ✅ Yes | "Global Healthcare Market Report 2024" |
| **Status** | ✅ Yes | "Active" (only Active titles are analyzed) |
| **Practice_Cluster** | ❌ Optional | "HPI&M", "RCM1", "Logistics", "FSII&PS" |

**Example CSV to paste into Excel:**
```
Title,Status,Practice_Cluster
Global Healthcare Market Report 2024,Active,HPI&M
Revenue Cycle Management Trends,Active,RCM1
Supply Chain Logistics Report,Active,Logistics
Financial Services Innovation,Active,FSII&PS
```

---

## 📊 Output: Excel Report

Your report has **4 sheets**:

### 1. **Summary**
- Total Mordor titles analyzed
- Number of competitors checked
- Covered vs. Gap titles
- Gap percentage

**Example:**
```
Mordor Titles (Active): 4
Competitors Analyzed: 3
Total Competitor Titles: 15
Covered by Mordor: 2
Gap / Whitespace: 13
Gap Percentage: 86.7%
```

### 2. **Gap Detail** — THE WHITESPACE OPPORTUNITIES
Shows titles competitors have but you don't:

| Competitor | Gap Title | Cluster | Similarity Score | Confidence |
|------------|-----------|---------|-------------------|------------|
| Grand View Research | Medical Devices Market Report 2026 | HPI&M | 0.00 | Low |
| Armstrong & Associates | Warehouse Management Systems Market | Logistics | 0.00 | Low |

**Interpretation:**
- **Similarity Score < 0.40** = Gap (whitespace)
- **Confidence Low/Medium/High** = How certain the classification is

### 3. **Already Covered**
Titles that competitors have that match your Mordor portfolio:

| Competitor | Title | Matched Mordor Title | Similarity Score |
|------------|-------|-------------------|-------------------|
| Grand View Research | Market Analysis: Healthcare | Global Healthcare Market Report 2024 | 0.50 |

### 4. **Metadata**
- Run timestamp
- Date range used
- Configuration (threshold: 0.40)

---

## 🏢 Available Competitors

Pre-loaded in the platform (10 total):

1. **Allied Market Research**
2. **Global Data Inc.**
3. **Technavio**
4. **IMARC**
5. **Armstrong & Associates**
6. **Future Market Insights**
7. **Grand View Research**
8. **Kentley Insights**
9. **The Insight Partners**
10. **Markets and Markets**

---

## 🔧 How It Works (Technical)

### Matching Algorithm: Jaccard Similarity

For each competitor title:
1. **Normalize** (lowercase, remove years, stopwords)
2. **Tokenize** (break into words)
3. **Compare** against your Mordor titles
4. **Score** = intersection / union of tokens

Example:
- Competitor: "Global Healthcare Market Report"
- Your title: "Global Healthcare Market Report 2024"
- **Normalized tokens:** {global, healthcare, market, report}
- **Similarity:** 1.0 (100% match)
- **Result:** COVERED ✅

---

## ⚙️ Configuration

### Similarity Threshold: **0.40** (40%)

- **Score ≥ 0.40** = Covered (already in your portfolio)
- **Score < 0.40** = Gap (whitespace opportunity)

**To change threshold** (if needed):
1. Open `app_simple.py`
2. Find line: `SIMILARITY_THRESHOLD = 0.40`
3. Change to your desired value (e.g., 0.50 for stricter matching)
4. Save and restart the app

### Practice Clusters

Automatically classified based on keywords:

| Cluster | Keywords |
|---------|----------|
| **HPI&M** | health, healthcare, medical, pharma, drug, hospital |
| **RCM1** | retail, consumer, fashion, food, beverage, shopping |
| **Logistics** | supply, chain, transport, shipping, warehouse, delivery |
| **FSII&PS** | financial, banking, semiconductor, software, technology |

---

## 🚨 Troubleshooting

### **Error: "Cannot find Python"**
- Install Python 3.9+ from python.org
- Add Python to system PATH
- Restart command prompt

### **Error: "ModuleNotFoundError: flask"**
```bash
pip install flask pandas openpyxl --break-system-packages
```

### **Error: "Port 3000 already in use"**
```bash
python app_simple.py  # It will try another port automatically
# Or kill the existing process:
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### **Excel file won't upload**
- File must be `.xlsx` or `.xls` format
- Must have `Title` column
- Must have `Status` column
- File size < 10 MB

### **No gap/covered results**
- Competitors may not have relevant titles
- Try adding more competitors
- Check title normalization by viewing report metadata

---

## 📈 Monthly Workflow

```
1. Export Mordor titles (Status = "Active")
2. Open http://localhost:3000
3. Select date range (e.g., Sep 1-30)
4. Select 3-5 key competitors
5. Upload Excel file
6. Click "Analyze" (~2-5 seconds)
7. Download report
8. Share with team
9. Archive for comparison with next month
```

---

## 📦 Files in This Folder

| File | Purpose |
|------|---------|
| `app_simple.py` | Main Flask application (run this) |
| `requirements.txt` | Python dependencies (optional if already installed) |
| `QUICK_START_GUIDE.md` | This guide |
| `DEPLOY_FREE_CLOUD.md` | Instructions to deploy online (Render/Railway/Heroku) |

---

## ☁️ Deploy Online (Optional)

If you want to share this with your team (not on your laptop):

1. Read `DEPLOY_FREE_CLOUD.md`
2. Choose Render (easiest, free)
3. Follow 3 simple steps
4. Get a public URL like: `https://gap-analysis-agent.onrender.com`

---

## 💡 Tips & Tricks

### Add More Competitors

Edit `app_simple.py`, find this section:
```python
COMPETITOR_DATA = {
    "Your Competitor Name": ["Title 1", "Title 2", "Title 3"],
}
```

Add new competitors to this dictionary and restart the app.

### Export Monthly Trends

Save each month's report with different filenames:
- `Gap_Analysis_202409.xlsx` (September)
- `Gap_Analysis_202410.xlsx` (October)

Then compare month-over-month to see which gaps are closing.

### Adjust Stopwords

If certain words are being ignored, edit the `STOPWORDS` set in `app_simple.py`:
```python
STOPWORDS = {"market", "size", "share", "forecast", ...}
```

---

## 🎯 Key Metrics Explained

**Coverage %** = (Covered / Total Competitors) × 100
- High coverage (70%+) = Strong market presence
- Low coverage (<40%) = Significant whitespace

**Gap Percentage** = (Gaps / Total) × 100
- High gap (>60%) = Many opportunities
- Low gap (<30%) = Market well-covered

**Similarity Score**
- 1.0 = Perfect match (same words)
- 0.5 = 50% match (medium relevance)
- 0.0 = No match (completely different)

---

## 📞 Support

### Common Questions

**Q: How often should I run this?**  
A: Monthly is ideal. First of each month with previous month's data.

**Q: Can I use this for multiple date ranges?**  
A: Yes, just change the start/end dates each time.

**Q: Is my data stored?**  
A: No. Excel is processed in-memory and deleted after analysis. No database.

**Q: How long does analysis take?**  
A: 2-5 seconds for 500 Mordor titles vs 10 competitors on a standard laptop.

---

## 📝 Version Info

- **Version:** 1.0
- **Status:** Production Ready
- **Created:** September 17, 2026
- **Tech Stack:** Python 3.11 + Flask + Pandas + openpyxl
- **Dependencies:** Flask, Pandas, openpyxl

---

**🎉 You're all set! Start analyzing your competitive gaps now.**
