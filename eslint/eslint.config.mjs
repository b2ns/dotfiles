import js from "@eslint/js";
import { defineConfig } from "eslint/config";
import globals from "globals";
import tseslint from "typescript-eslint";
import reactPlugin from "eslint-plugin-react";
import reactHooksPlugin from "eslint-plugin-react-hooks";
import eslintConfigPrettier from "eslint-config-prettier";

export default defineConfig(
  // 1. Base JavaScript recommended rules
  js.configs.recommended,

  // 2. Strict TypeScript rules (use .recommended for less strict)
  ...tseslint.configs.recommended,

  // 3. React specific configurations
  {
    files: ["**/*.{ts,tsx}"],
    plugins: {
      react: reactPlugin,
      "react-hooks": reactHooksPlugin,
    },
    languageOptions: {
      parserOptions: {
        ecmaFeatures: { jsx: true },
      },
      globals: {
        ...globals.browser,
      },
    },
    settings: {
      react: { version: "detect" }, // Automatically detect React version
    },
    rules: {
      ...reactPlugin.configs.flat.recommended.rules,
      ...reactPlugin.configs.flat["jsx-runtime"].rules, // Required for React 17+
      ...reactHooksPlugin.configs.recommended.rules,

      // Custom overrides
      "react/react-in-jsx-scope": "off", // Not needed in modern React
      "react/prop-types": "off", // Not needed when using TypeScript
    },
  },

  // 4. Global ignores (replaces .eslintignore)
  {
    ignores: ["dist/", "node_modules/", "build/"],
  },

  eslintConfigPrettier,
);
