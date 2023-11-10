from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from PyPDF2 import PdfReader
from io import BytesIO
import docx
import spacy
import os

app = FastAPI()

# Load spaCy model
nlp = spacy.load("en_core_web_sm")


@app.post("/cv/analyze")
async def analyze_cv(file: UploadFile = File(...)):
    # Check file extension
    if file.filename.endswith(".pdf"):
        text = await read_pdf(file)
    elif file.filename.endswith(".docx"):
        text = await read_docx(file)
    else:
        raise HTTPException(
            status_code=400,
            detail="Invalid file format. Please upload a .docx or .pdf file.",
        )

    # Analyze the CV and calculate scores
    score, feedback = analyze_text(text)

    return {"score": score, "feedback": feedback}


async def read_pdf(file: UploadFile) -> str:
    content = await file.read()
    content_io = BytesIO(content)
    pdf = PdfReader(content_io)
    text = ""
    for page in pdf.pages:
        text += page.extract_text()
    return text


async def read_docx(file: UploadFile) -> str:
    contents = await file.read()
    doc = docx.Document(BytesIO(contents))
    text = "\n".join([paragraph.text for paragraph in doc.paragraphs])
    return text


def analyze_text(text: str) -> tuple:
    doc = nlp(text)

    # Here you would have more complex analysis to calculate the scores based on your criteria
    # For demonstration purposes, we're keeping it simple.
    total_score = calculate_total_score(doc)
    feedback = generate_feedback(doc)

    return total_score, feedback


def calculate_total_score(doc) -> int:
    # Initialize individual scores to zero
    impact_score, readability_score, brevity_score, custom_score = 0, 0, 0, 0

    # 1. Impact score based on the use of action verbs often associated with impactful language.
    action_verbs = {
        "achieved",
        "completed",
        "expanded",
        "influenced",
        "pioneered",
        "reduced",
        "resolved",
    }
    for token in doc:
        if token.lemma_ in action_verbs:
            impact_score += 1

    # 2. Readability score based on sentence length (simplistic readability metric).
    for sent in doc.sents:
        if (
            15 < len(sent) < 25
        ):  # Typically, sentences of 15-25 words are considered easily readable.
            readability_score += 1

    # 3. Brevity score based on the overall length of the CV.
    # This is a simplistic measure, as ideally, you'd want to check the content's density and relevance.
    total_words = len([token for token in doc if not token.is_stop])
    if (
        250 < total_words < 600
    ):  # Arbitrary word counts, adjust based on typical expectations for your field.
        brevity_score = 5

    # 4. Custom score based on whatever other criteria you're interested in.
    # For instance, you might check for the presence of specific skills, keywords, or qualifications.
    important_skills = {
        "leadership",
        "management",
        "communication",
        "research",
        "programming",
    }
    for token in doc:
        if token.lemma_.lower() in important_skills:
            custom_score += 2

    # Combine scores (consider weighting categories based on their importance)
    total_score = impact_score + readability_score + brevity_score + custom_score

    normalized_total_score = int((total_score / 40) * 100)
    return normalized_total_score


def generate_feedback(doc) -> dict:
    # Initialize feedback dictionary with categories.
    feedback = {
        "Impact": "",
        "Brevity": "",
        "Style": "",
        "Sections": "",
        "Soft Skills": "",
    }

    # Criteria for impactful language (using action verbs).
    action_verbs = {
        "achieved",
        "completed",
        "expanded",
        "influenced",
        "pioneered",
        "reduced",
        "resolved",
    }
    action_verbs_used = [token.text for token in doc if token.lemma_ in action_verbs]

    if action_verbs_used:
        feedback[
            "Impact"
        ] = f"Good use of impactful language with verbs such as {', '.join(action_verbs_used)}. Consider using more action verbs to highlight your contributions."
    else:
        feedback[
            "Impact"
        ] = "Could not find impactful action verbs. Use more action-oriented language to demonstrate your contributions (e.g., 'achieved', 'improved', 'resolved')."

    # Analyze sentence length to give feedback on brevity and readability.
    long_sentences = [
        sent for sent in doc.sents if len(sent) > 30
    ]  # Assuming more than 30 words is lengthy.

    if long_sentences:
        feedback[
            "Brevity"
        ] = f"Found {len(long_sentences)} long sentences. Consider shortening for brevity and clarity."
    else:
        feedback[
            "Brevity"
        ] = "Good sentence length. The text is concise and easy to read."

    # For style, we might comment on the variety of sentence structures, vocabulary, etc. This example is simplified.
    feedback[
        "Style"
    ] = "Ensure a consistent style. Avoid mixing tenses and first/third person. Formal, professional language is recommended."

    # Analyzing structure might involve checking the order of sections, their relevance, etc.
    # We would need more complex parsing to analyze document structure properly. For now, we provide generic advice.
    feedback[
        "Sections"
    ] = "Check the sequence of sections. Customize the order to highlight your strengths related to the target position."

    # Feedback on soft skills might involve checking for mention of interpersonal skills and examples demonstrating them.
    soft_skills_mentioned = [
        "teamwork",
        "communication",
        "adaptability",
        "problem-solving",
        "creativity",
    ]
    soft_skills_found = [
        skill for skill in soft_skills_mentioned if skill in doc.text.lower()
    ]

    if soft_skills_found:
        feedback[
            "Soft Skills"
        ] = f"Good mention of soft skills: {', '.join(soft_skills_found)}. Provide specific examples or situations where you demonstrated these skills."
    else:
        feedback[
            "Soft Skills"
        ] = "No mention of key soft skills. Consider including skills like 'communication', 'teamwork', or 'problem-solving', with examples."

    return feedback
