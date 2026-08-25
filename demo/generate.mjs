#!/usr/bin/env node
/**
 * Deterministic e-commerce suite generator for the Smarter Testing demo.
 *
 * Re-run: node demo/generate.mjs
 * A second run must be a no-op (identical bytes).
 *
 * TIA demo hook (edit this one file on a feature branch):
 *   demo/src/pricing/quote.js
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SRC_ROOT = path.join(__dirname, "src");
const MANIFEST_PATH = path.join(__dirname, "generated-manifest.json");

const TIA_HOOK = { domain: "pricing", module: "quote" };

const LEGACY_TOP_LEVEL = [
  "cart.js",
  "checkout.js",
  "inventory.js",
  "pricing.js",
  "shipping.js",
  "users.js",
];

const DOMAINS = [
  {
    name: "cart",
    testsPerModule: 32,
    modules: [
      "addItem",
      "removeItem",
      "mergeCarts",
      "guestCart",
      "abandonedCart",
      "lineItem",
      "quantityGuard",
      "cartSubtotal",
      "cartWeight",
      "giftWrap",
      "saveForLater",
      "cartExpiry",
      "cartCurrency",
      "cartNotes",
    ],
    vocab: ["mug", "tee", "hoodie", "sticker", "bottle", "tote", "cap", "socks"],
  },
  {
    name: "catalog",
    testsPerModule: 32,
    modules: [
      "productSlug",
      "variantSku",
      "categoryTree",
      "searchIndex",
      "facetFilter",
      "productBadge",
      "catalogSort",
      "merchandising",
      "collectionRules",
      "relatedSkus",
      "catalogLocale",
      "productStatus",
      "catalogFeed",
      "catalogCache",
    ],
    vocab: ["denim", "ceramic", "oak", "linen", "brass", "wool", "canvas", "silk"],
  },
  {
    name: "checkout",
    testsPerModule: 36,
    modules: [
      "placeOrder",
      "orderNumber",
      "checkoutHold",
      "addressValidate",
      "giftMessage",
      "orderConfirm",
      "checkoutSession",
      "splitShipment",
      "orderNotes",
      "checkoutLock",
      "digitalFulfill",
      "pickupWindow",
      "orderChannel",
      "checkoutAudit",
      "guestCheckout",
    ],
    vocab: ["guest", "member", "pickup", "digital", "split", "hold", "express", "retail"],
  },
  {
    name: "coupons",
    testsPerModule: 36,
    modules: [
      "couponCode",
      "stackRules",
      "minSpend",
      "expiryWindow",
      "firstOrder",
      "referralCredit",
      "couponBudget",
      "percentOff",
      "amountOff",
      "skuRestrict",
      "couponAudit",
      "couponLocale",
      "flashCode",
      "loyaltyBoost",
      "couponFraud",
    ],
    vocab: ["welcome", "flash", "loyalty", "referral", "clearance", "holiday", "app", "vip"],
  },
  {
    name: "inventory",
    testsPerModule: 40,
    modules: [
      "stockLevel",
      "reserveUnits",
      "releaseHold",
      "backorder",
      "safetyStock",
      "warehouseBin",
      "lotNumber",
      "inventorySync",
      "shrinkAdjust",
      "transferStock",
      "cycleCount",
      "inventoryAlert",
      "inboundAsn",
      "allocation",
      "inventoryLock",
      "sellableQty",
    ],
    vocab: ["east", "west", "bulk", "retail", "returns", "overflow", "cold", "hazmat"],
  },
  {
    name: "payments",
    testsPerModule: 42,
    modules: [
      "chargeCard",
      "refundCapture",
      "payoutSplit",
      "walletPay",
      "paymentAuth",
      "fraudScore",
      "paymentRetry",
      "settleBatch",
      "chargeback",
      "paymentMethod",
      "tokenVault",
      "paymentCurrency",
      "installment",
      "paymentWebhook",
      "captureDelay",
      "paymentReceipt",
    ],
    vocab: ["visa", "amex", "wallet", "ach", "klarna", "paypal", "apple", "store"],
  },
  {
    name: "pricing",
    testsPerModule: 44,
    modules: [
      "quote",
      "markdown",
      "volumeDiscount",
      "currencyConvert",
      "priceList",
      "mapPrice",
      "promoPrice",
      "bundlePrice",
      "tierPrice",
      "surgePrice",
      "contractPrice",
      "roundingRule",
      "priceBook",
      "competitorMatch",
      "clearance",
      "memberPrice",
      "priceGuard",
      "listPrice",
    ],
    vocab: ["list", "promo", "member", "clearance", "bundle", "contract", "map", "surge"],
  },
  {
    name: "recommendations",
    testsPerModule: 46,
    modules: [
      "similarItems",
      "boughtTogether",
      "trendingNow",
      "recentlyViewed",
      "personalized",
      "seasonalPick",
      "staffPick",
      "refillReminder",
      "completeTheSet",
      "becauseYouViewed",
      "affinityScore",
      "recencyBoost",
      "coldStart",
      "categoryReco",
      "wishlistNudge",
      "cartReco",
      "emailReco",
      "homepageRail",
    ],
    vocab: ["home", "email", "cart", "pdp", "search", "app", "sms", "loyalty"],
  },
  {
    name: "shipping",
    testsPerModule: 50,
    modules: [
      "rateShop",
      "zoneLookup",
      "packingSlip",
      "labelPrint",
      "carrierPick",
      "transitDays",
      "dimWeight",
      "signatureReq",
      "holdAtLocation",
      "shippingQuote",
      "weekendCut",
      "ruralSurcharge",
      "boxRecommend",
      "shipNotify",
      "returnLabel",
      "expedite",
      "freightClass",
      "customsHs",
      "pickupScan",
      "deliveryWindow",
    ],
    vocab: ["ground", "express", "overnight", "freight", "pickup", "locker", "rural", "intl"],
  },
  {
    name: "tax",
    testsPerModule: 52,
    modules: [
      "salesTax",
      "vatRate",
      "nexusCheck",
      "taxExempt",
      "taxInclusive",
      "withholding",
      "taxHoliday",
      "destination",
      "originTax",
      "taxIdValidate",
      "reverseCharge",
      "taxRounding",
      "taxAudit",
      "digitalTax",
      "marketplaceFacil",
      "taxEstimate",
      "exemptionCert",
      "taxJurisdiction",
      "taxReport",
      "useTax",
    ],
    vocab: ["ca", "ny", "tx", "wa", "ie", "de", "jp", "gb"],
  },
  {
    name: "users",
    testsPerModule: 56,
    modules: [
      "userProfile",
      "passwordReset",
      "sessionToken",
      "roleGuard",
      "emailVerify",
      "twoFactor",
      "addressBook",
      "userPrefs",
      "accountLock",
      "gdprExport",
      "consentFlag",
      "loginThrottle",
      "userMerge",
      "loyaltyTier",
      "userAudit",
      "avatarUpload",
      "notificationPref",
      "closeAccount",
      "guestUpgrade",
      "orgMember",
      "userLocale",
      "deviceTrust",
    ],
    vocab: ["shopper", "admin", "guest", "reseller", "support", "buyer", "owner", "auditor"],
  },
  {
    name: "warehouse",
    testsPerModule: 64,
    modules: [
      "pickList",
      "packStation",
      "putaway",
      "wavePick",
      "dockDoor",
      "toteAssign",
      "slotting",
      "replenish",
      "yardCheck",
      "cycleSlot",
      "freezeHold",
      "lotPick",
      "serialScan",
      "palletBuild",
      "shipLane",
      "returnsBin",
      "kitting",
      "crossDock",
      "laborTask",
      "warehouseMap",
      "hazardFlag",
      "pickPath",
      "packVerify",
      "outboundScan",
    ],
    vocab: ["a1", "b2", "c3", "dock", "cold", "bulk", "returns", "hazmat"],
  },
];

function fnv1a(str) {
  let h = 2166136261;
  for (let i = 0; i < str.length; i += 1) {
    h ^= str.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return h >>> 0;
}

function capitalize(name) {
  return name.charAt(0).toUpperCase() + name.slice(1);
}

function money(amount, factor, unit) {
  return Math.round((amount * factor + unit) * 100) / 100;
}

function moduleConstants(domain, moduleName) {
  const seed = fnv1a(`${domain}/${moduleName}`);
  return {
    unit: 1 + (seed % 9),
    factorBase: 100 + (seed % 40),
  };
}

function sourceFile({ domain, moduleName, unit, factorBase }) {
  const feeName = `${moduleName}WithFee`;
  const clampName = `clamp${capitalize(moduleName)}`;
  const isHook = domain === TIA_HOOK.domain && moduleName === TIA_HOOK.module;
  const header = isHook
    ? [
        "// TIA demo hook: edit this file on a feature branch after main has impact data.",
        "// Generated by demo/generate.mjs — do not edit the rest by hand.",
      ].join("\n")
    : "// Generated by demo/generate.mjs — do not edit by hand.";

  return `${header}
"use strict";

const UNIT = ${unit};
const FACTOR_BASE = ${factorBase};

function ${moduleName}(amount, factor) {
  return Math.round((amount * factor + UNIT) * 100) / 100;
}

function ${feeName}(amount, factor, fee) {
  return ${moduleName}(amount, factor) + fee;
}

function ${clampName}(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function factorFromBps(bps) {
  return (FACTOR_BASE + bps) / 100;
}

module.exports = {
  UNIT,
  FACTOR_BASE,
  ${moduleName},
  ${feeName},
  ${clampName},
  factorFromBps,
};
`;
}

function testFile({ domain, moduleName, testsPerModule, vocab, unit, factorBase }) {
  const feeName = `${moduleName}WithFee`;
  const clampName = `clamp${capitalize(moduleName)}`;
  const cases = [];

  for (let i = 0; i < testsPerModule; i += 1) {
    const h = fnv1a(`${domain}/${moduleName}/case/${i}`);
    const item = vocab[h % vocab.length];
    const amount = 8 + (h % 240);
    const bps = h % 25;
    const factor = (factorBase + bps) / 100;
    const fee = h % 15;
    const quoted = money(amount, factor, unit);
    const kind = i % 3;

    if (kind === 0) {
      cases.push({
        name: `computes ${moduleName} for a ${item} ${domain} row ${i + 1}`,
        kind: "base",
        amount,
        bps,
        expected: quoted,
      });
    } else if (kind === 1) {
      cases.push({
        name: `applies the ${moduleName} fee path for a ${item} ${domain} row ${i + 1}`,
        kind: "fee",
        amount,
        bps,
        fee,
        expected: quoted + fee,
      });
    } else {
      const min = Math.round(quoted) - 2;
      const max = Math.round(quoted) + 2;
      cases.push({
        name: `clamps ${moduleName} for a ${item} ${domain} row ${i + 1}`,
        kind: "clamp",
        value: quoted + ((h % 7) - 3),
        min,
        max,
        expected: Math.min(max, Math.max(min, quoted + ((h % 7) - 3))),
      });
    }
  }

  const caseLines = cases
    .map((c) => {
      if (c.kind === "base") {
        return `  ["${c.name}", "base", ${c.amount}, ${c.bps}, ${c.expected}],`;
      }
      if (c.kind === "fee") {
        return `  ["${c.name}", "fee", ${c.amount}, ${c.bps}, ${c.expected}, ${c.fee}],`;
      }
      return `  ["${c.name}", "clamp", ${c.value}, ${c.min}, ${c.expected}, ${c.max}],`;
    })
    .join("\n");

  return `// Generated by demo/generate.mjs — do not edit by hand.
"use strict";

const {
  ${moduleName},
  ${feeName},
  ${clampName},
  factorFromBps,
} = require("./${moduleName}");
const { delay } = require("../testSupport/delay");

const cases = [
${caseLines}
];

for (const [name, kind, a, b, expected, extra] of cases) {
  test(name, async () => {
    await delay();
    if (kind === "base") {
      expect(${moduleName}(a, factorFromBps(b))).toBe(expected);
    } else if (kind === "fee") {
      expect(${feeName}(a, factorFromBps(b), extra)).toBe(expected);
    } else {
      expect(${clampName}(a, b, extra)).toBe(expected);
    }
  });
}
`;
}

function cleanTree() {
  for (const name of LEGACY_TOP_LEVEL) {
    const file = path.join(SRC_ROOT, name);
    if (fs.existsSync(file)) {
      fs.unlinkSync(file);
    }
  }
  const legacyTests = path.join(SRC_ROOT, "__tests__");
  if (fs.existsSync(legacyTests)) {
    fs.rmSync(legacyTests, { recursive: true, force: true });
  }
  for (const domain of DOMAINS) {
    const dir = path.join(SRC_ROOT, domain.name);
    fs.rmSync(dir, { recursive: true, force: true });
    fs.mkdirSync(dir, { recursive: true });
  }
}

function writeAll() {
  const manifest = {
    generatedBy: "demo/generate.mjs",
    tiaHook: `demo/src/${TIA_HOOK.domain}/${TIA_HOOK.module}.js`,
    tiaHookTests: `demo/src/${TIA_HOOK.domain}/${TIA_HOOK.module}.test.js`,
    domains: [],
    moduleCount: 0,
    testFileCount: 0,
    testCount: 0,
  };

  for (const domain of DOMAINS) {
    const domainInfo = {
      name: domain.name,
      modules: domain.modules.length,
      testsPerModule: domain.testsPerModule,
      tests: domain.modules.length * domain.testsPerModule,
    };
    manifest.domains.push(domainInfo);

    for (const moduleName of domain.modules) {
      const { unit, factorBase } = moduleConstants(domain.name, moduleName);
      const src = sourceFile({
        domain: domain.name,
        moduleName,
        unit,
        factorBase,
      });
      const test = testFile({
        domain: domain.name,
        moduleName,
        testsPerModule: domain.testsPerModule,
        vocab: domain.vocab,
        unit,
        factorBase,
      });
      fs.writeFileSync(path.join(SRC_ROOT, domain.name, `${moduleName}.js`), src);
      fs.writeFileSync(path.join(SRC_ROOT, domain.name, `${moduleName}.test.js`), test);
      manifest.moduleCount += 1;
      manifest.testFileCount += 1;
      manifest.testCount += domain.testsPerModule;
    }
  }

  fs.writeFileSync(MANIFEST_PATH, `${JSON.stringify(manifest, null, 2)}\n`);
  return manifest;
}

cleanTree();
const manifest = writeAll();
process.stdout.write(
  `Wrote ${manifest.moduleCount} modules, ${manifest.testFileCount} test files, ${manifest.testCount} tests.\n` +
    `TIA hook: ${manifest.tiaHook}\n`,
);
