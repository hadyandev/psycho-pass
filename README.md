# 🧠 Psycho-Pass PsychoToken Smart Contract

## ❓ Problem Statement

Tracking and rewarding user behavior or scores is usually done off-chain, which can lead to lack of transparency, possible data manipulation, and limited automation.

## 🔧 Current Solution & Limitations

Most systems rely on centralized databases to store scores and manage rewards, but this:

- ⚠️ Makes it hard for users to verify their scores and rewards.
- 🔒 Can be manipulated by administrators.
- 💸 Doesn’t provide on-chain tokens that users can hold or trade.
- ⏳ Requires manual work to distribute rewards fairly.

## 🚀 Solution Overview

This smart contract on the Stacks blockchain provides:

- 📊 On-chain storage of user psycho-scores and their history.
- 🎁 Automated token rewards based on score levels:
  - ✅ Full rewards if score is **Clear**
  - ⚠️ Half rewards if score is **Caution**
  - 🔥 Token burn if score is **Danger**
- 💰 Standard SIP-010 fungible token features like transfer, mint, and burn.
- 🛠️ Admin control to update scores and manage tokens.

## 🌟 Value Proposition

- 🔍 Transparent and tamper-proof score and reward tracking on blockchain.
- ⚖️ Fair and automatic reward distribution.
- 🎫 Users receive tokens that can be transferred or used in other apps.
- 🔗 Compatible with existing Stacks wallets and tools.

## 🎬 Inspiration

This project is inspired by the anime **Psycho-Pass**, which explores the concept of measuring a person’s psychological state and assigning a "crime coefficient" score. The smart contract mimics this idea by assigning psycho-scores to users and rewarding them accordingly on-chain.

## 🏷️ Contract Address

Deployed on Stacks Testnet at: [https://explorer.hiro.so/txid/ST34EFSRM1QD0PX8QWQZBHZBQSKXHWPBV5MXTAA7Y.psycho-score-test2?chain=testnet](Psycho-Pass Smart Contract)

## 🔗 Related Frontend Repo (Work in Progress)

You can check out the frontend repository here (still under active development):

[https://github.com/hadyandev/psycho-pass-ui](https://github.com/hadyandev/psycho-pass-ui)

---

Feel free to contribute or open issues for improvements!  
Happy hacking! 🚀
