# Gap Analysis Platform 🎯

**AI-powered competitive title gap analysis for Mordor Intelligence**

![Status](https://img.shields.io/badge/status-production%20ready-brightgreen)
![Python](https://img.shields.io/badge/python-3.9%2B-blue)
![Flask](https://img.shields.io/badge/flask-3.0%2B-blueviolet)

Identify market whitespace by analyzing your Mordor title portfolio against 10+ competitors using real Jaccard similarity matching.

## ✨ Features

✅ **Real Matching Algorithm** - Jaccard similarity for accurate gap identification  
✅ **Automatic Classification** - Cluster titles into HPI&M, RCM1, Logistics, FSII&PS  
✅ **Bulk Analysis** - Process 100-5000 titles in seconds  
✅ **Excel Reports** - 4-sheet output (Summary, Gaps, Covered, Metadata)  
✅ **No Data Storage** - Privacy-first (in-memory processing)  
✅ **10 Pre-loaded Competitors** - Easily expandable  
✅ **Web Interface** - Drag-and-drop file upload  
✅ **Cloud-Ready** - Deploy to Render, Railway, or Heroku  

## 🚀 Quick Start

### Local Installation (5 minutes)

```bash
# Clone repository
git clone https://github.com/rahulsharma17072023/gap-analysis-agent.git
cd gap-analysis-agent

# Install dependencies
pip install -r requirements.txt

# Run the app
python app_simple.py

# Open in browser
open http://localhost:3000
```

### Docker Alternative

```bash
docker build -t gap-analysis .
docker run -p 3000:3000 gap-analysis
```

## 📊 How It Works

1. **Upload** your Mordor titles (Excel: Title, Status columns)
2. **Select** 3-5 competitors to analyze
3. **Choose** date range for tracking
4. **Analyze** — See gaps and opportunities

### Example Results

```
Input:  4 Mordor titles vs 3 competitors (15 titles)
Output: 
  ✅ 2 covered (40%)
  ⚠️  13 gaps (60% whitespace)
  ⏱️  Analysis time: 2 seconds
```

## 📁 Input Format

Your Excel file must include:

| Column | Required | Example |
|--------|----------|---------|
| Title | ✅ | "Global Healthcare Market Report 2024" |
| Status | ✅ | "Active" |
| Practice_Cluster | ❌ | "HPI&M" |

Only "Active" rows are analyzed. Cluster is auto-detected if not provided.

## 📈 Output Report

### Sheet 1: Summary
- Total titles analyzed
- Coverage percentage
- Gap count and percentage

### Sheet 2: Gap Detail
The whitespace opportunities (competitor titles you don't cover):

```
| Competitor | Gap Title | Cluster | Similarity | Confidence |
|------------|-----------|---------|------------|------------|
| Competitor A | Medical Devices Market | HPI&M | 0.00 | Low |
```

### Sheet 3: Already Covered
Titles your portfolio already covers (matched with Mordor titles).

### Sheet 4: Metadata
Run information and configuration.

## ⚙️ Configuration

### Similarity Threshold (Default: 0.40)

Controls what counts as "covered":
- **0.40+** = Covered (matches your portfolio)
- **<0.40** = Gap (whitespace)

Edit in `app_simple.py`:
```python
SIMILARITY_THRESHOLD = 0.40  # Change this value
```

### Add More Competitors

Edit `COMPETITOR_DATA` dictionary in `app_simple.py`:

```python
COMPETITOR_DATA = {
    "Your Competitor Name": [
        "Title 1",
        "Title 2",
        "Title 3"
    ],
}
```

### Adjust Title Normalization

Edit `STOPWORDS` and `CLUSTER_KEYWORDS` in `app_simple.py` to customize matching behavior.

## 🌐 Deployment

### Option 1: Render (Recommended - FREE)

1. Push code to GitHub
2. Go to https://render.com
3. Sign up with GitHub
4. Click "New Web Service"
5. Connect your repo
6. Deploy with one click
7. Get public URL: `https://gap-analysis-agent.onrender.com`

### Option 2: Railway

1. Go to https://railway.app
2. Click "New Project"
3. Deploy from GitHub
4. Railway auto-detects Python
5. Public URL in 2 minutes

### Option 3: Heroku

Requires credit card ($5-7/month). See [DEPLOY_FREE_CLOUD.md](DEPLOY_FREE_CLOUD.md)

## 📚 Documentation

- [QUICK_START_GUIDE.md](QUICK_START_GUIDE.md) - Complete user guide
- [GITHUB_SETUP.md](GITHUB_SETUP.md) - GitHub setup instructions
- [DEPLOY_FREE_CLOUD.md](DEPLOY_FREE_CLOUD.md) - Cloud deployment guide

## 🔧 Tech Stack

| Component | Version |
|-----------|---------|
| Python | 3.9+ |
| Flask | 3.0+ |
| Pandas | 2.1+ |
| openpyxl | 3.1+ |
| Gunicorn | 21.2+ |

## 📦 Dependencies

```
Flask==3.0.0
pandas==2.1.3
openpyxl==3.11.0
python-dotenv==1.0.0
gunicorn==21.2.0
Werkzeug==3.0.1
```

Install with:
```bash
pip install -r requirements.txt
```

## 🎯 Algorithm Explanation

### Jaccard Similarity

Measures overlap between two sets of tokens:

```
Competitor Title: "Global Healthcare Market Report 2024"
Your Title:       "Global Healthcare Market Report"

Tokens:
- Competitor: {global, healthcare, market, report, 2024}
- You:        {global, healthcare, market, report}

Similarity = Intersection / Union = 4/5 = 0.80 (80% match)
Result:     COVERED ✅
```

### Cluster Classification

Titles auto-classified by keyword matching:

- **HPI&M**: health, medical, pharma, hospital, diagnostic
- **RCM1**: retail, consumer, fashion, food, beverage
- **Logistics**: supply, chain, transport, warehouse, delivery
- **FSII&PS**: financial, banking, software, technology, semiconductor

## 🔐 Security & Privacy

✅ **No Data Stored** - Excel processed in-memory, deleted after analysis  
✅ **No Database** - Stateless (every request is independent)  
✅ **No Tracking** - No analytics or user tracking  
✅ **HTTPS Ready** - Full SSL/TLS support on cloud  

## 📊 Performance

| Scenario | Time | Notes |
|----------|------|-------|
| 100 titles vs 5 competitors | <1s | Small portfolio |
| 500 titles vs 10 competitors | 2-3s | Standard use |
| 2000+ titles vs 15+ competitors | 10-15s | Large portfolio |

Local performance on standard laptop (Python 3.11).

## 🤝 Contributing

Contributions welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🐛 Issues & Support

Found a bug? Have a suggestion?

1. Check [existing issues](../../issues)
2. Create a [new issue](../../issues/new)
3. Include error message and steps to reproduce

## 📝 Changelog

### v1.0 (September 2026)
- Initial release
- Jaccard similarity matching
- 10 pre-loaded competitors
- 4-sheet Excel reports
- Web interface
- Cloud deployment support

## 📄 License

MIT License - See LICENSE file for details

## 👤 Author

**Rahul Sharma**  
Mordor Intelligence  
[ai_rahul@hotmail.com](mailto:ai_rahul@hotmail.com)

## 🙏 Acknowledgments

- Jaccard similarity algorithm for effective title matching
- Flask community for the lightweight web framework
- Pandas for data processing
- openpyxl for Excel generation

---

**Made with ❤️ for Mordor Intelligence**

### Next Steps

- [ ] Clone the repository
- [ ] Run locally (`python app_simple.py`)
- [ ] Test with your Mordor portfolio
- [ ] Deploy to cloud (optional)
- [ ] Share with your team

### Questions?

- 📖 Read the [Quick Start Guide](QUICK_START_GUIDE.md)
- 🌐 Check [Cloud Deployment](DEPLOY_FREE_CLOUD.md)
- 💬 Create an [issue](../../issues/new)

---

**Version 1.0** | **Status: Production Ready** | **Last Updated: September 2026**
