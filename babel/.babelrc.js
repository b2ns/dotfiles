const presets = [[
    '@babel/preset-env',
    // {useBuiltIns: 'usage', corejs: 3}
], [
    '@babel/preset-react',
]];

const plugins = [[
    '@babel/plugin-transform-runtime',
    {corejs: 3}
], [
    '@babel/plugin-syntax-dynamic-import'
]];

module.exports = {presets, plugins};
