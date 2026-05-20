![Python](https://img.shields.io/badge/Python-3.10+-blue) ![FastAPI](https://img.shields.io/badge/FastAPI-0.95+-green) ![Docker](https://img.shields.io/badge/Docker-ready-blue) ![License](https://img.shields.io/badge/License-MIT-yellow)
````markdown
# Text-Classification-API

A production-style **German-language short-text classifier** served as a FastAPI microservice and packaged with Docker.

The pipeline takes raw German text input, validates it (German characters only, no numbers or emails), preprocesses it (tokenisation + German stopword removal), and predicts a category label using a TF-IDF + Linear SVM model trained offline.

## What it does

- **Input:** German short text via a simple HTML form or HTTP POST to `/predict/`
- **Output:** Predicted category label (decoded from a serialised `LabelEncoder`)
- **Input validation layer:** rejects non-German characters, numbers, or email addresses before inference

## Architecture

```
User input (German text)
        │
        ▼
   Input validation  ──►  reject if non-German / contains numbers / emails
        │
        ▼
   Preprocessing
   ├── Lowercase
   ├── Tokenize (NLTK)
   └── Remove German stopwords
        │
        ▼
   TF-IDF Vectoriser (.joblib)  ──►  sparse feature vector
        │
        ▼
   Linear SVM (.joblib)  ──►  numeric class prediction
        │
        ▼
   Label Encoder (.joblib)  ──►  human-readable category
        │
        ▼
   FastAPI JSON response
```

## Tech stack

| Layer | Library |
|---|---|
| API | FastAPI · Uvicorn |
| ML | scikit-learn (TF-IDF, LinearSVC) · joblib |
| NLP | NLTK (German tokenizer · German stopwords) |
| Packaging | Docker |
| Language | Python 3 |

## Repository structure

```
.
├── main.py                   # FastAPI app + endpoints + input validation
├── mdamin199.ipynb           # EDA, training pipeline, and evaluation
├── svm_classifier.joblib     # Trained Linear SVM
├── tfidf_vectorizer.joblib   # Fitted TF-IDF vectoriser
├── label_encoder.joblib      # LabelEncoder for class names
├── requirements.txt
├── Dockerfile
└── README.md
```

## Run with Docker

```bash
# Build
docker build -t text-classification-api .

# Run (maps container port 80 to host port 8000)
docker run -d -p 8000:80 text-classification-api
```

Open `http://localhost:8000` in your browser for the input form, or POST directly:

```bash
curl -X POST http://localhost:8000/predict/ \
     -F "text=Ihre deutsche Eingabe hier"
```

## Run without Docker

```bash
pip install -r requirements.txt
python -m nltk.downloader punkt stopwords
uvicorn main:app --host 0.0.0.0 --port 8000
```

## Design notes

- Model artefacts (`*.joblib`) are committed for reproducible inference; for retraining, see `mdamin199.ipynb`
- Optimised for **short-text** classification — long-document tasks would benefit from additional document-length features
- The project originated as a take-home exercise; the modelling pipeline, validation layer, and containerisation choices are mine

## Future work

- Replace TF-IDF + SVM with a German transformer baseline (e.g. `bert-base-german-cased` or `deepset/gbert-base`) for accuracy upside
- Add `pytest` test suite + GitHub Actions CI
- Add `/health` endpoint and structured logging
- Production-grade serving with Gunicorn + Nginx
````
