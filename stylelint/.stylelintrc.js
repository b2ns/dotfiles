module.exports = {
  defaultSeverity: 'warning',
  // extends: 'stylelint-config-standard',
  plugins: [],
  rules: {
    'color-no-invalid-hex': true,
    'font-family-no-duplicate-names': true,
    // 'font-family-no-missing-generic-family-keyword': true,
    'function-calc-no-invalid': true,
    'function-calc-no-unspaced-operator': true,
    'function-linear-gradient-no-nonstandard-direction': true,
    'string-no-newline': true,
    'unit-no-unknown': true,
    'property-no-unknown': true,
    'keyframe-declaration-no-important': true,
    'declaration-block-no-duplicate-properties': true,
    'declaration-block-no-shorthand-property-overrides': true,
    'block-no-empty': true,
    'selector-pseudo-class-no-unknown': true,
    'selector-pseudo-element-no-unknown': [
      true,
      {ignorePseudoElements: ['v-deep']},
    ],
    'selector-type-no-unknown': true,
    'media-feature-name-no-unknown': true,
    'at-rule-no-unknown': true,
    'comment-no-empty': true,
    'no-duplicate-selectors': true,
    'no-extra-semicolons': true,

    'value-no-vendor-prefix': true,
    'property-no-vendor-prefix': true,
    'declaration-block-single-line-max-declarations': 1,
    'selector-max-empty-lines': 0,
    'at-rule-no-vendor-prefix': true,

    'color-hex-case': 'lower',
    'color-hex-length': 'short',
    'function-parentheses-space-inside': 'never',
    // 'number-leading-zero': 'never',
    'string-quotes': 'single',
    // 'length-zero-no-unit': true,
    'unit-case': 'lower',
    'value-keyword-case': 'lower',
    'property-case': 'lower',
    'declaration-colon-space-after': 'always',
    'declaration-colon-space-before': 'never',
    'declaration-block-trailing-semicolon': 'always',
    'selector-attribute-brackets-space-inside': 'never',
    'selector-combinator-space-after': 'always',
    'selector-combinator-space-before': 'always',
    'selector-pseudo-class-parentheses-space-inside': 'never',
    'selector-pseudo-element-colon-notation': 'double',
    'media-feature-colon-space-after': 'always',
    'media-feature-colon-space-before': 'never',
    'media-feature-parentheses-space-inside': 'never',
    'media-feature-range-operator-space-after': 'always',
    'media-feature-range-operator-space-before': 'always',
    'at-rule-name-space-after': 'always',
    'at-rule-semicolon-space-before': 'never',
    indentation: 2,
  },
};