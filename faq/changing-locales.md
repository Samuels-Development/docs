# How Do I Change Locales?

All of our scripts support multiple languages. To change the language, open the `config.lua` file for the resource and find the `Locale` setting near the top.

## Changing the Locale

```lua
Config.Locale = 'en' -- Change to your preferred language
```

### Available Languages

The available locales vary by script. Common options include:

| Code | Language |
|------|----------|
| `en` | English |
| `de` | German (Deutsch) |
| `es` | Spanish (Espanol) |
| `fr` | French (Francais) |
| `ar` | Arabic |

::: tip
Check the `locales/` folder inside each resource to see which translations are available. Each `.lua` file in that folder represents a supported language.
:::

## Adding a Custom Locale

1. Navigate to the `locales/` folder of the resource
2. Copy an existing locale file (e.g., `en.lua`)
3. Rename it to your language code (e.g., `pt.lua` for Portuguese)
4. Translate all strings in the file
5. Update `Config.Locale` to your new language code

```lua
Config.Locale = 'pt' -- Your custom locale
```

::: warning
Make sure all keys from the original locale file exist in your translation. Missing keys will cause errors or display raw key names in-game.
:::
