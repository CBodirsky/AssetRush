Asset Rush

A data‑driven trading prototype built on top of a tycoon framework.

Asset Rush is a systems‑focused Roblox prototype exploring deterministic pricing, data‑driven item definitions, real‑time UI synchronization, and server‑authoritative inventory management. The project sits on top of a lightweight tycoon framework and layers a fully custom market system, display system, and inventory system on top.

This repository contains the core logic behind the trading economy — not the full game — and is intended as a portfolio showcase of engineering patterns, architecture, and system design.

Project Overview

Asset Rush simulates a small, fast‑moving marketplace where item prices fluctuate on fixed intervals. All servers generate identical prices using deterministic seeds, eliminating the need for cross‑server communication. Players can buy and sell items, watch prices rise and fall in real time, and manage a slot‑based inventory.

This repo includes:

    Deterministic pricing engine

    Epoch‑aligned timer system

    Data‑driven item definitions

    Real‑time display and UI updates

    Server‑authoritative inventory system

    Integration with an inherited tycoon framework

    Experimental prototypes and scaffolding for future features

It intentionally excludes:

    Assets

    UI

    Models

    Place files

    Proprietary content

Only the logic is included.

Architecture Overview
Code

src/
  Server/
    Core/                -- inherited tycoon framework + bootstrap
    InventorySystem/     -- slot-based inventory
    MarketSystem/        -- pricing, timers, item metadata
    API/                 -- server endpoints for client UI
  Client/
    DisplaySystem/       -- model injection, price labels, timers

Core Concepts

    Data‑driven design: Items, prices, intervals, and display metadata live in structured tables.

    Deterministic randomness: All servers generate identical prices using epoch‑aligned seeds.

    Separation of concerns: Pricing, display, inventory, and player lifecycle are isolated modules.

    Extensibility: Systems are modular and easy to expand (new items, strategies, intervals, etc.).

Market System
Deterministic Pricing

The pricing engine uses:

    epoch (aligned to interval boundaries)

    itemId hashing

    strategy‑based distribution shaping

This ensures:

    all servers produce identical prices

    no cross‑server locking is required

    prices feel dynamic but predictable

Key files:

ItemManager.lua	Generates deterministic prices per item and per group.

PriceSeedStrategy.lua	Strategy-based price shaping (uniform, steady, bipolar).

TimerManager.lua	Epoch-aligned refresh scheduling.

ItemDefinitionsList.lua	Metadata for all items (min/max, strategy, display info).

TimerIntervals.lua	Centralized refresh intervals.

GlobalPriceStore.lua	Optional DataStore persistence (not required for determinism).

TimerLockPrototype.lua	Early experiment with cross-server locking (deprecated).

Inventory System

A server‑authoritative, slot‑based inventory system that tracks:

    itemId

    purchase price

    rarity flags

    timestamps

    max slot limits

Key file:  
InventoryService.lua

This system is intentionally simple but fully extensible for future upgrades (e.g., housing, expansions, rebirth bonuses).
Display System

The display layer dynamically assembles TradeStands and item visuals based on metadata, and updates UI elements in real time.

Highlights:

    Injects item models into the world

    Sets name and price labels

    Flashes green/red on price changes

    Updates countdown timers

    Uses Formatting utilities for consistent currency display

Key files:

InjectModels.lua	Places item models and updates price labels.

PanelBuilder.lua	Builds TradeStand models from definitions.

TimerDisplays.lua	Updates countdown timers.

Formatting.lua	Currency formatting utilities.

Core Framework (Inherited)

The project uses a lightweight tycoon framework for:

    spawn ownership

    unlockable components

    rebirth/reset logic

    player lifecycle

    component-based behaviors via CollectionService tags

These files are not the focus of the repo but are included for context.

Key files:

Tycoon.lua	Core tycoon instance logic (inherited).

PlayerManager.lua	Player data, leaderstats, gamepasses (inherited).

Server.lua	Bootstrap and tycoon assignment.

ProductHandler.lua	Placeholder for future monetization.

Experimental / Prototype Code

The repo includes early experiments that were replaced by better designs. These are included intentionally to show engineering reasoning.

    TimerLockPrototype.lua — attempted cross‑server locking using MemoryStore

    Replaced by deterministic pricing

These files demonstrate your ability to iterate, test ideas, and pivot to simpler, more reliable solutions.
Technical Highlights

    Deterministic pricing across all servers

    Epoch-aligned timers for predictable refresh cycles

    Strategy-based price shaping using math functions

    Data-driven item definitions for easy expansion

    Real-time UI synchronization with TweenService feedback

    Server-authoritative inventory with slot limits

    Clean client/server API boundaries

    Integration with an existing framework without breaking architecture

Purpose of This Repository

This repo is a portfolio showcase of:

    system design

    modular architecture

    deterministic algorithms

    clean Lua engineering

    integration with existing frameworks

    thoughtful iteration and refactoring

It is not a full game release and intentionally omits assets and proprietary content.
