# CrowdFunding
# Crowdfund – A Crowdfunding Smart Contract

> **A crowdfunding contract built with Solidity**, designed to handle donations, deadlines, refunds, and withdrawals with clear outcome logic.

---

## Overview

**Crowdfund** is a Ethereum smart contract that enables a transparent and secure crowdfunding campaign.

## Features

-Accepts ETH donations until the campaign **deadline**  
-Finalizes the outcome (Successful / Failed)  
-Owner-only withdrawal when the **goal** is met  
-**Refunds available** to all donors if the goal fails  
-Transparent events for tracking all key actions  

---

## Contract Details

| Variable | Description |
|-----------|--------------|
| `owner` | Address of campaign creator |
| `goal` | Target amount (in wei) |
| `deadline` | UNIX timestamp marking campaign end |
| `raised` | Total ETH collected so far |
| `finalized` | Marks whether campaign is finalized |
| `donations` | Mapping of donor addresses to their contribution |
| `outcome` | Enum — `Ongoing`, `Successful`, or `Failed` |

---
