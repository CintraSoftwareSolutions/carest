# Carest — Privacy Policy

_Last updated: 2026-09-18_

> **Note for the developer/client:** This is a content document to be turned into an HTML privacy-policy page. Fill in every `[TODO: ...]` placeholder and read Section 15 before publishing. Remove Section 15 from the public version.

---

## 1. Overview & Scope

Carest ("the App", "we", "us", "our") is a faith and emotional well-being mobile application that helps you "cast your cares" — privately writing down what weighs on your heart, receiving a gentle reflection, and releasing it. The App also offers an optional apparel store and the option to make a donation to support the App.

This Privacy Policy explains what information the App collects, how it is used, who it is shared with, how it is protected, and the choices you have. It applies to the Carest mobile app published under the identifier **`com.castyourcare.app`** on Google Play and the Apple App Store.

**You do not create an account or sign in to use Carest.** On first launch the App assigns your device an anonymous identifier (via Firebase Anonymous Authentication) so it can remember your settings and progress on that device. You are never required to provide your name, email, or any other personal detail to use the core experience — you share such details only if you choose to (for example, to fill in a profile, place a store order, make a donation, or set up cross-device recovery).

By downloading or using the App, you agree to this Policy. If you do not agree, please do not use the App.

---

## 2. Information We Collect

Carest is built to collect as little as possible. Most people can use it without ever entering personal information. The App stores the following in our secure cloud backend (Google Firebase / Cloud Firestore), associated only with your device's anonymous identifier:

**Collected automatically (no personal identity required):**

- **Anonymous device identifier** — a random ID from Firebase Anonymous Authentication used to save your data on your device. It is not your name, email, or phone number.
- **Burdens-released count** — a simple number tracking how many times you have cast a care.
- **App settings** — your preferences, such as background music on/off and in-app notifications on/off.
- **In-app notifications** — messages the App shows you inside the app (for example, an order or donation confirmation).

**Collected only if you choose to provide it:**

- **Profile details** — an optional full name, email address, phone number, and a profile photo you pick from your device. The photo is downsized and stored as a small image with your profile.
- **Delivery information** — if you place a store order, the name, email, phone, country, and address you enter (saved so it can be pre-filled next time).
- **Shopping cart** — the items you add to your cart (product references and quantities).
- **Order records** — a record of orders you place (items, totals, delivery details, status).
- **Donation records** — a record of donations you make (amount, method, status).
- **Cross-device recovery credentials** — if you set up "Sync Across Devices", a username you choose and a one-way hashed version of your PIN (we do not store the PIN itself), plus a copy of your profile so you can restore it on another device.

**Important:** The App does **not** require or request a login, and does not collect your name, email, or phone unless you enter them yourself for one of the features above.

---

## 3. The Words You Write ("Cast" Text) and AI Reflections

The words you type when casting a care are treated as private. **We do not save them to our database, and we do not keep a log or history of them.**

To offer a gentle, personalized reflection, the App can generate suggestions based on what you wrote. When this happens, the text you entered is sent — over an encrypted connection — to our secure server function (Google Cloud Functions) and on to Google's Gemini AI service (the Generative Language API), which returns the reflection. This text is used only to produce that reflection in the moment. It is not stored by us, and is not used to advertise to you or to build a profile of you.

If the AI service is unavailable, the App falls back to gentle, pre-written reflections generated on your device, and no text leaves your phone.

Google processes this text as our service provider. See Google's privacy terms in **Section 5**. If you would prefer not to send any text off your device, you can simply not use the AI suggestions and cast your care without them.

---

## 4. How We Use Your Information

We use the information described above only to operate and improve the App, specifically to:

- Provide the core cast-and-release experience and show relevant scripture and reflections.
- Keep your personal count of burdens released and remember your app settings.
- Generate AI reflections from the text you write (see Section 3).
- Power the optional store: display products, manage your cart, and process orders and delivery.
- Process donations you choose to make.
- Enable optional cross-device recovery so you can restore your profile on another device.
- Show in-app notifications such as order and donation confirmations.
- Keep the App secure, prevent abuse, and diagnose technical problems.

We do **not** sell your personal information, we do **not** use it for third-party advertising, and we do **not** build advertising or behavioral profiles about you.

---

## 5. Third-Party Services & Data Sharing

We do not sell your data. We share it only with the service providers below, and only as needed for the features you use. Each provider processes data under its own privacy policy.

| Provider | Role in the App | What it receives |
| --- | --- | --- |
| **Google Firebase** (Anonymous Auth, Cloud Firestore, Cloud Functions) — Google LLC | Hosts our backend: your anonymous ID, stored data, and server functions | Your anonymous ID and the data listed in Section 2 |
| **Google Gemini** — Generative Language API, Google LLC | Generates AI reflections | The text you write when casting (see Section 3); not stored |
| **Stripe** — Stripe, Inc. | Processes donation payments | Payment/card details you enter and the donation amount (see Section 6) |
| **Shopify** — Shopify Inc. | Powers the store catalog and secure checkout | Product browsing, and any purchase, shipping, and payment details you enter at checkout (see Section 6) |

Provider privacy policies: [Google Privacy Policy](https://policies.google.com/privacy) · [Firebase / Google Cloud data processing](https://firebase.google.com/support/privacy) · [Google APIs Terms](https://developers.google.com/terms) · [Stripe Privacy Policy](https://stripe.com/privacy) · [Shopify Privacy Policy](https://www.shopify.com/legal/privacy).

We may also disclose information if required by law, to enforce our terms, or to protect the rights, safety, and security of our users and the App.

---

## 6. Payments and Store Purchases

**Donations (Stripe).** When you make a donation, your card details are entered directly into Stripe's secure payment sheet. **We never see or store your full card number or security code.** Our server function creates a payment request (a Stripe "PaymentIntent") and Stripe processes the charge. We keep only a record that a donation was made (amount, method, status). Stripe handles card data under its own PCI-compliant systems and privacy policy.

**Store purchases (Shopify).** Browsing the store loads products from Shopify. When you check out, the App opens Shopify's secure hosted checkout in your browser. Any purchase, shipping, and payment details you enter there are collected and processed by Shopify under Shopify's privacy policy; we do not receive your card details. Delivery information you type inside the App (name, email, phone, country, address) is saved to your device's record so it can be pre-filled next time.

---

## 7. Data Storage, Security, Retention & Deletion

**Where your data is stored.** Your data is stored in Google Firebase / Google Cloud infrastructure. Firebase operates data centers in the United States and other regions. `[TODO for client: confirm your Firebase/Firestore project region and name it here.]`

**Security.** All communication between the App and our servers uses encrypted connections (HTTPS/TLS). Access to stored data is restricted by Firestore Security Rules so that each device can read and write only its own data. Recovery PINs are stored only as a one-way hash, never in plain text. Card payments are handled by Stripe and Shopify on their PCI-compliant systems.

**Retention.** We keep your data only while it is needed to provide the App — typically until you delete it. Because there is no account tied to your identity, data remains associated with your device's anonymous ID.

**How to delete your data.**

- **Log out** in the App to start a fresh anonymous identity; this releases the previous anonymous session on your device.
- **Uninstall** the App to remove its data from your device.
- **Cross-device recovery data** (a username record you created) and any order or donation records held on our servers can be deleted on request — contact us (Section 14) and we will delete them, subject to legal retention requirements for financial/transaction records held by Stripe or Shopify.

---

## 8. Device Permissions

The App requests only the permissions it needs:

- **Internet / network access** — required to load content, generate reflections, and run the store and donations.
- **Photos / gallery access** — requested only if you choose to set a profile photo. The App uses your device's standard photo picker to let you select a single image; it does not browse or upload your photo library.

The App does **not** access your precise location, contacts, camera, microphone, calendar, health or fitness sensors, or SMS. The App does not send push notifications; "notifications" in the App refer to messages shown inside the App.

---

## 9. Your Privacy Rights & Choices

You can exercise the following at any time:

- **Access & correct** — view and edit your profile details in the App at any time.
- **Delete** — clear your profile, log out to start fresh, or uninstall the App (see Section 7). You may also contact us to delete server-side records.
- **Opt out of AI processing** — cast your care without using the AI suggestions so no text leaves your device.
- **Control settings** — turn music and in-app notifications on or off.

**If you are in the EEA, UK, or Switzerland (GDPR):** you have the right to access, rectify, erase, restrict, or object to processing of your personal data, and to data portability. Where we rely on consent, you may withdraw it at any time.

**If you are a California resident (CCPA/CPRA):** you have the right to know what personal information is collected, to request deletion, to correct it, and to opt out of "sale" or "sharing" of personal information. **We do not sell or share your personal information for cross-context behavioral advertising.** We will not discriminate against you for exercising your rights.

To make any request, contact us using Section 14. Because the App is anonymous, we may need information to locate your data (for example, your recovery username), and we may be unable to identify device-only data that you have already deleted by uninstalling.

---

## 10. Children's Privacy

Carest is intended for a general audience and is not directed to children under 13 (or under 16 in the EEA and UK). We do not knowingly collect personal information from children. If you believe a child has provided us personal information, please contact us (Section 14) and we will delete it.

---

## 11. App Store & Google Play Privacy Disclosures

This table maps Carest's data practices to the categories used by Google Play's **Data safety** form and Apple's **App Privacy** label. Data is collected only when you use the relevant feature. "Linked to you" means tied to identifying details you entered; most data is tied only to an anonymous device ID.

| Data type | Collected? | Purpose | Shared with | Linked to you? |
| --- | --- | --- | --- | --- |
| Device / anonymous identifier | Yes | App functionality | Google (Firebase) | No |
| Name | Only if you enter it | Profile, delivery, donation | Google; Shopify at checkout | Yes |
| Email address | Only if you enter it | Profile, delivery, donation | Google; Shopify at checkout | Yes |
| Phone number | Only if you enter it | Profile, delivery | Google; Shopify at checkout | Yes |
| Physical address | Only if you order | Order delivery | Google; Shopify | Yes |
| Photos | Only if you set one | Profile photo | Google (Firebase) | Yes |
| Purchase history | Only if you order/donate | Orders, donations | Google; Shopify; Stripe | Yes |
| Payment info | Only at payment | Process payment | Stripe; Shopify (not stored by us) | By processor |
| User content (text you write) | Sent for AI, not stored | Generate reflection | Google (Gemini) | No |
| App activity (count, settings, cart) | Yes | App functionality | Google (Firebase) | No |

**Data used for tracking / advertising:** none. Carest does not use data to track you across other companies' apps or websites, and includes no advertising SDKs.

`[TODO for client: enter these same answers in the Google Play Data safety form and the Apple App Privacy questionnaire so they match this policy.]`

---

## 12. International Users & Legal Bases

Carest is operated using Google Cloud/Firebase infrastructure, and your information may be processed and stored in the United States and other countries where our service providers operate. These countries may have data-protection laws different from those in your country. Where required, our providers rely on recognized transfer mechanisms (such as Standard Contractual Clauses) for international transfers.

Where GDPR applies, our legal bases for processing are:

- **Consent** — for optional features you choose, such as entering a profile, adding a photo, or sending text for an AI reflection.
- **Performance of a contract** — to fulfil store orders and process donations you initiate.
- **Legitimate interests** — to run, secure, and improve the core App experience in a privacy-protective way.

---

## 13. Changes to This Policy

We may update this Privacy Policy from time to time, for example when we add features or change providers. When we do, we will revise the "last updated" date at the top and, for significant changes, provide notice in the App or on the App's store listing. Your continued use of the App after an update means you accept the revised Policy. We encourage you to review this Policy periodically.

---

## 14. Contact Us

If you have questions about this Privacy Policy or want to make a privacy request, contact:

- **Operator / legal entity:** `[TODO: company or individual name]`
- **Email:** `[TODO: privacy contact email]`
- **Mailing address:** `[TODO: postal address, if required by your jurisdiction]`

We will respond to privacy requests within the time required by applicable law.

---

## 15. Notes for the Developer / Client (remove before publishing)

Fill these in before this policy goes live on a public URL:

- [ ] **Legal entity / operator name** (Sections 1 and 14).
- [ ] **Privacy contact email** and, if required, **mailing address** (Section 14).
- [ ] **Effective / last-updated date** (shown at the top of the page).
- [ ] **Governing jurisdiction** for legal-terms purposes (add a line if your lawyer requires it).
- [ ] **Confirm the Firebase/Firestore project region** and name it in Section 7.
- [ ] **Publish this policy at a public HTTPS URL** and paste that URL into: the Google Play listing, the Apple App Store Connect listing, and the App's in-app Privacy Policy link.

**Accuracy flag (important):** The App's current in-app Privacy screen text says the words you write are "never stored, logged, or transmitted to any server." That is accurate for storage, but the AI reflection feature **does transmit** the text to a Cloud Function and Google's Gemini API to generate suggestions (see Section 3). Reconcile the in-app wording with this policy — either update the in-app copy to match Section 3, or disable the server-side AI and use only the on-device fallback. Do not publish the "never transmitted" claim while server-side AI is enabled.

**Data-source note:** This document was written from the app's actual implementation (Firebase Anonymous Auth, Cloud Firestore, Cloud Functions, Gemini, Stripe, Shopify, and the optional profile/photo and username-recovery features). If any of these change, update the matching section and the store disclosures.

---

_This policy reflects Carest's data practices as of the date shown at the top. Please re-review it whenever the App's features, providers, or data handling change._
