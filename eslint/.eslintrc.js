module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    commonjs: true,
    es2022: true,
  },
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react/recommended',
    'plugin:react/jsx-runtime',
    'plugin:react-hooks/recommended',
    'prettier',
  ],
  plugins: ['@typescript-eslint', 'react'],
  rules: {
    // Override default rules
    'no-constant-condition': ['error', { checkLoops: false }],

    // Possible Problems
    'no-constant-binary-expression': 'error',
    'no-constructor-return': 'error',
    'no-self-compare': 'error',
    'no-unmodified-loop-condition': 'error',
    'no-unused-private-class-members': 'warn',
    'require-atomic-updates': 'error',

    // Suggestions
    'arrow-body-style': 'warn',
    'dot-notation': 'error',
    eqeqeq: ['error', 'smart'],
    'no-array-constructor': 'error',
    'no-caller': 'error',
    'no-console': 'warn',
    'no-eval': 'error',
    'no-extend-native': 'error',
    'no-extra-bind': 'warn',
    'no-implicit-coercion': 'warn',
    'no-implied-eval': 'error',
    'no-invalid-this': 'error',
    'no-label-var': 'error',
    'no-loop-func': 'error',
    // 'no-mixed-operators': 'error',
    // 'no-negated-condition': 'warn',
    'no-new-func': 'error',
    'no-new-object': 'error',
    'no-proto': 'error',
    // 'no-return-assign': 'error',
    'no-undefined': 'error',
    'no-unneeded-ternary': 'warn',
    'no-unused-vars': [
      'warn',
      { varsIgnorePattern: '^_+$', argsIgnorePattern: '^_+|h$' },
    ],
    // 'no-unused-expressions': 'warn',
    'no-useless-call': 'warn',
    'no-useless-computed-key': 'warn',
    'no-useless-concat': 'warn',
    'no-useless-rename': 'warn',
    'no-useless-return': 'warn',
    'no-var': 'error',
    'object-shorthand': 'warn',
    'prefer-const': [
      'warn',
      {
        destructuring: 'all',
        ignoreReadBeforeAssign: true,
      },
    ],
    'prefer-rest-params': 'warn',
    'prefer-spread': 'warn',
    // 'prefer-template': 'warn',
    'quote-props': ['warn', 'as-needed'],
    // 'require-unicode-regexp': 'warn',
    'spaced-comment': 'warn',

    // Layout & Formatting
    'array-bracket-newline': 'warn',
    'array-bracket-spacing': ['warn', 'never'],
    'arrow-parens': 'warn',
    'arrow-spacing': 'warn',
    'block-spacing': 'warn',
    'brace-style': ['warn', '1tbs', { allowSingleLine: true }],
    'comma-dangle': ['warn', 'only-multiline'],
    'comma-spacing': 'warn',
    'comma-style': 'warn',
    'computed-property-spacing': 'warn',
    // 'eol-last': 'warn',
    'func-call-spacing': 'warn',
    // 'function-paren-newline': 'warn',
    'generator-star-spacing': 'warn',
    // 'implicit-arrow-linebreak': 'warn',
    // 'indent': ['warn', 2],
    'jsx-quotes': 'warn',
    'key-spacing': 'warn',
    'keyword-spacing': 'warn',
    'lines-between-class-members': 'warn',
    'no-multi-spaces': 'warn',
    'no-trailing-spaces': 'warn',
    'no-whitespace-before-property': 'warn',
    'object-curly-newline': 'warn',
    'object-curly-spacing': ['warn', 'always'],
    quotes: [
      'warn',
      'single',
      { avoidEscape: true, allowTemplateLiterals: true },
    ],
    'rest-spread-spacing': 'warn',
    // semi: 'warn',
    semi: 0,
    'semi-spacing': 'warn',
    'semi-style': 'warn',
    'space-before-blocks': 'warn',
    'space-before-function-paren': ['warn', { named: 'never' }],
    'space-in-parens': 'warn',
    'space-infix-ops': 'warn',
    'space-unary-ops': 'warn',
    'switch-colon-spacing': 'warn',
    'template-curly-spacing': 'warn',
    'template-tag-spacing': 'warn',
    'yield-star-spacing': 'warn',
  },
}
