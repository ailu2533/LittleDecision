import json
import os
import logging
from typing import Dict, Any

def load_json_file(file_path: str) -> Dict[str, Any]:
    """加载JSON文件并返回其内容"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return json.load(file)
    except FileNotFoundError:
        logging.error(f"文件未找到: {file_path}")
        raise
    except json.JSONDecodeError:
        logging.error(f"JSON解析错误: {file_path}")
        raise

def get_languages(data: Dict[str, Any]) -> set:
    """从数据中提取所有可用的语言代码"""
    languages = set()
    for string_data in data['strings'].values():
        if 'localizations' in string_data:
            languages.update(string_data['localizations'].keys())
    return languages

def extract_translations(data: Dict[str, Any], languages: set) -> Dict[str, Dict[str, str]]:
    """提取每种语言的翻译"""
    translations = {lang: {} for lang in languages}
    for key, string_data in data['strings'].items():
        if 'localizations' in string_data:
            for lang, localization in string_data['localizations'].items():
                if 'stringUnit' in localization and 'value' in localization['stringUnit']:
                    translations[lang][key] = localization['stringUnit']['value']
    return translations

def save_translations(translations: Dict[str, Dict[str, str]], output_dir: str):
    """将每种语言的翻译保存到单独的JSON文件中"""
    os.makedirs(output_dir, exist_ok=True)
    for lang, trans in translations.items():
        filename = os.path.join(output_dir, f'Localizable.{lang}.json')
        with open(filename, 'w', encoding='utf-8') as file:
            json.dump(trans, file, ensure_ascii=False, indent=2)

def main():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    
    input_file = '/Users/luai/Documents/LittleDecision/LittleDecision/Localizable.xcstrings'
    output_dir = 'translations'
    
    try:
        data = load_json_file(input_file)
        languages = get_languages(data)
        translations = extract_translations(data, languages)
        save_translations(translations, output_dir)
        logging.info(f"翻译文件已生成在 {output_dir} 目录下。")
    except Exception as e:
        logging.error(f"处理过程中发生错误: {str(e)}")

if __name__ == "__main__":
    main()