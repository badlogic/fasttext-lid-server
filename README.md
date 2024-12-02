# FastText Language ID Server

HTTP server that provides language identification using [FastText language identification models](https://fasttext.cc/docs/en/language-identification.html). The default build comes with lid.176.ftz built-in and supports 176 languages:

| Code | Language |
|--------|-----------|
| af | Afrikaans |
| als | Alemannic |
| am | Amharic |
| an | Aragonese |
| ar | Arabic |
| arz | Egyptian Arabic |
| as | Assamese |
| ast | Asturian |
| av | Avaric |
| az | Azerbaijani |
| azb | South Azerbaijani |
| ba | Bashkir |
| bar | Bavarian |
| bcl | Central Bikol |
| be | Belarusian |
| bg | Bulgarian |
| bh | Bhojpuri |
| bn | Bengali |
| bo | Tibetan |
| bpy | Bishnupriya |
| br | Breton |
| bs | Bosnian |
| bxr | Buryat |
| ca | Catalan |
| cbk | Chavacano |
| ce | Chechen |
| ceb | Cebuano |
| ckb | Central Kurdish |
| co | Corsican |
| cs | Czech |
| cv | Chuvash |
| cy | Welsh |
| da | Danish |
| de | German |
| diq | Zazaki |
| dsb | Lower Sorbian |
| dty | Doteli |
| dv | Divehi |
| el | Greek |
| eml | Emilian-Romagnol |
| en | English |
| eo | Esperanto |
| es | Spanish |
| et | Estonian |
| eu | Basque |
| fa | Persian |
| fi | Finnish |
| fr | French |
| frr | North Frisian |
| fy | West Frisian |
| ga | Irish |
| gd | Scottish Gaelic |
| gl | Galician |
| gn | Guarani |
| gom | Goan Konkani |
| gu | Gujarati |
| gv | Manx |
| he | Hebrew |
| hi | Hindi |
| hif | Fiji Hindi |
| hr | Croatian |
| hsb | Upper Sorbian |
| ht | Haitian Creole |
| hu | Hungarian |
| hy | Armenian |
| ia | Interlingua |
| id | Indonesian |
| ie | Interlingue |
| ilo | Iloko |
| io | Ido |
| is | Icelandic |
| it | Italian |
| ja | Japanese |
| jbo | Lojban |
| jv | Javanese |
| ka | Georgian |
| kk | Kazakh |
| km | Khmer |
| kn | Kannada |
| ko | Korean |
| krc | Karachay-Balkar |
| ku | Kurdish |
| kv | Komi |
| kw | Cornish |
| ky | Kyrgyz |
| la | Latin |
| lb | Luxembourgish |
| lez | Lezgian |
| li | Limburgish |
| lmo | Lombard |
| lo | Lao |
| lrc | Northern Luri |
| lt | Lithuanian |
| lv | Latvian |
| mai | Maithili |
| mg | Malagasy |
| mhr | Eastern Mari |
| min | Minangkabau |
| mk | Macedonian |
| ml | Malayalam |
| mn | Mongolian |
| mr | Marathi |
| mrj | Western Mari |
| ms | Malay |
| mt | Maltese |
| mwl | Mirandese |
| my | Burmese |
| myv | Erzya |
| mzn | Mazanderani |
| nah | Nahuatl |
| nap | Neapolitan |
| nds | Low German |
| ne | Nepali |
| new | Newari |
| nl | Dutch |
| nn | Norwegian Nynorsk |
| no | Norwegian |
| oc | Occitan |
| or | Odia |
| os | Ossetian |
| pa | Punjabi |
| pam | Pampanga |
| pfl | Palatine German |
| pl | Polish |
| pms | Piedmontese |
| pnb | Western Punjabi |
| ps | Pashto |
| pt | Portuguese |
| qu | Quechua |
| rm | Romansh |
| ro | Romanian |
| ru | Russian |
| rue | Rusyn |
| sa | Sanskrit |
| sah | Sakha |
| sc | Sardinian |
| scn | Sicilian |
| sco | Scots |
| sd | Sindhi |
| sh | Serbo-Croatian |
| si | Sinhala |
| sk | Slovak |
| sl | Slovenian |
| so | Somali |
| sq | Albanian |
| sr | Serbian |
| su | Sundanese |
| sv | Swedish |
| sw | Swahili |
| ta | Tamil |
| te | Telugu |
| tg | Tajik |
| th | Thai |
| tk | Turkmen |
| tl | Tagalog |
| tr | Turkish |
| tt | Tatar |
| tyv | Tuvan |
| ug | Uyghur |
| uk | Ukrainian |
| ur | Urdu |
| uz | Uzbek |
| vec | Venetian |
| vep | Veps |
| vi | Vietnamese |
| vls | West Flemish |
| vo | Volapük |
| wa | Walloon |
| war | Waray |
| wuu | Wu Chinese |
| xal | Kalmyk |
| xmf | Mingrelian |
| yi | Yiddish |
| yo | Yoruba |
| yue | Cantonese |
| zh | Chinese |

## Quick Start

```bash
# Run with default settings
docker compose up

# Run with custom port
PORT=9000 docker compose up

# Test
curl "http://localhost:8080/detect?text=Hello%20world"
```

## API

### GET /detect
- **Parameter**: `text` (required)
- **Response**: JSON with language code and probability
```json
{
    "language": "en",
    "probability": 0.987
}
```
- **Errors**:
  - 400: Missing text parameter
  - 500: Prediction failed

## Building

Prerequisites: CMake 3.14+, C++17 compiler

```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
```

## Running

```bash
./fasttext_lid_server [model_path] [port]
```

## Docker

### Using docker run
```bash
# Build
docker build -t fasttext-lid-server .

# Run with defaults
docker run -p 8080:8080 fasttext-lid-server

# Run with custom port and local model file
docker run -p 9000:9000 \
  -e PORT=9000 \
  -e MODEL_FILE=/models/custom.ftz \
  -v $(pwd)/models:/models \
  fasttext-lid-server
```

### Using docker compose
```yaml
version: '3.8'

services:
  lid-server:
    build: .
    ports:
      - "${PORT:-8080}:${PORT:-8080}"
    environment:
      - MODEL_FILE=${MODEL_FILE:-lid.176.ftz}
      - PORT=${PORT:-8080}
    volumes:
      - ./models:/models  # Optional: mount local models directory
```

Run with:
```bash
# Default settings
docker compose up

# Custom port
PORT=9000 docker compose up

# Custom model
MODEL_FILE=/models/custom.ftz docker compose up
```