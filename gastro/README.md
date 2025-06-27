# Gastronet 🍽️  
**Decentralized Culinary Expertise Network**

Gastronet is a Clarity-based smart contract platform that empowers chefs to register, share recipes, collaborate in the kitchen, and review each other's culinary skills in a decentralized and trustless environment.

---

## 🔥 Features

- **Chef Registration & Profiles**
  - Onboard culinary professionals with rich profiles detailing their specialty and background.

- **Recipe Publishing**
  - Chefs can publish signature recipes with metadata, tracked and stored immutably on-chain.

- **Recipe Approval System**
  - Master chefs can approve recipes to indicate quality, originality, or mastery.

- **Culinary Skill Reviews**
  - Peer-to-peer chef reviews on specific culinary skills (e.g., plating, fusion, baking).

- **Kitchen Collaboration**
  - Decentralized tracking of collaborations between chefs.

---

## 🛠️ Smart Contract Overview

### Constants

- `executive-chef`: The deploying address.
- `err-chef-only`, `err-culinary-not-found`, etc.: Error codes for common issues.

### Data Storage

- **Maps**:
  - `chefs`: Stores chef profiles.
  - `recipes`: Stores recipe metadata and approval status.
  - `taste-reviews`: Tracks culinary peer reviews.
  - `kitchen-collaborations`: Tracks bilateral collaborations between chefs.

- **Variables**:
  - `next-chef-id`: Unique chef ID counter.
  - `next-recipe-id`: Unique recipe ID counter.

---

## 📚 Function Reference

### 🔓 Public Functions

- `register-chef(...)`: Registers a new chef with background info.
- `update-chef-profile(...)`: Updates chef profile details.
- `submit-recipe(...)`: Publishes a new recipe.
- `approve-recipe(...)`: Approves a recipe if you're the assigned master chef.
- `review-culinary-skills(...)`: Leave skill-based peer reviews.
- `start-kitchen-collaboration(...)`: Begins a culinary collaboration between two chefs.

### 👁️ Read-Only Functions

- `get-chef-profile(...)`: View any chef's profile.
- `get-recipe-details(...)`: Fetch recipe data by ID.
- `are-kitchen-collaborating(...)`: Check if two chefs are collaborating.
- `get-taste-review(...)`: View a specific peer review.
- `is-recipe-approved(...)`: Verify recipe approval status.
- `get-next-recipe-id`: Get the upcoming recipe ID.
