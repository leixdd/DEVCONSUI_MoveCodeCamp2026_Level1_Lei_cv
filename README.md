# 📘 Sui Move Smart Contracts Portfolio — Level 1

## 📌 Project Overview

**Project Name:**  
**Sui Move Smart Contracts Portfolio – Level 1**

**Project Description:**  
Sui Move Smart Contracts Portfolio Level 1 is a beginner-friendly portfolio project created for the **Move Smart Contracts Code Camp**. It combines a modern frontend portfolio with an introductory Move smart contract to demonstrate foundational Web3 concepts on the **Sui blockchain**.

This project focuses on:
- Showcasing student profile information through a responsive React frontend
- Introducing Move smart contracts and Sui’s object-centric data model
- Serving as a Level 1 submission and learning baseline for future blockchain integrations

---

## 🚀 How to Run the Project (Full Guide)

This project is intended to be run using **WSL (Windows Subsystem for Linux)**.

📖 **Complete setup, installation, and execution guide:**  
👉 https://docs.google.com/document/d/1NEB75rMSBGCcSsA9iX69iroe2TdUpYOmXfJMOr0tSck/edit?usp=sharing

> ⚠️ Please follow the Google Doc step-by-step for:
> - Installing dependencies  
> - Running the frontend  
> - Publishing the Move smart contract  
> - Using the Sui CLI  

---

## ✨ Features

### 🧑‍🎓 Section 1: Hero / Profile
- Profile image
- Full name display
- Course and school information
- Social media links (LinkedIn & GitHub)

### 📝 Section 2: About & Skills
- Personal bio / description
- Skills list (minimum of 5 skills)

### ⛓️ Section 3: Move Smart Contracts
- Educational explanation of the Move programming language
- Overview of Sui blockchain concepts
- “Learn More” button linking to official Sui documentation

### 🧾 Section 4: Footer
- DEVCON & SUI logos
- Code Camp attribution

---

## 👀 Project Visual Preview

This project renders a **single-page portfolio layout** that includes:
- A hero profile section
- About & skills section
- Move smart contracts educational card
- Footer with DEVCON Philippines & Sui Foundation branding

> You may insert screenshots here if required.

---

## 🗂️ Project Structure

```text
sui_portfolio_level1/
├── portfolio_contract/          # Move smart contracts
│   ├── Move.toml               # Package configuration
│   ├── sources/
│   │   └── portfolio.move      # Main Move contract
│   └── tests/
│       └── portfolio_test.move
│
└── portfolio_frontend/         # React frontend application
    ├── public/
    │   ├── profile.png
    │   ├── sui-logo.png
    │   ├── devcon.png
    │   └── sui.svg
    │
    ├── src/
    │   ├── App.tsx
    │   ├── App.css
    │   ├── main.tsx
    │   └── views/
    │       └── PortfolioView.tsx
    │
    ├── index.html
    ├── package.json
    ├── tailwind.config.js
    └── vite.config.ts
