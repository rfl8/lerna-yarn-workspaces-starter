module.exports = {
  env: {
    development: {
      compact: false
    }
  },
  plugins: ['babel-plugin-styled-components'],
  presets: ['@babel/preset-env', '@babel/preset-react']
}
