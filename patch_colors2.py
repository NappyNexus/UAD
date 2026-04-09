import os
import re

VIEWS_DIR = 'lib/views'

def patch_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    original = content
    
    # 1. Colors.white inside color: active ? Color(...) : Colors.white
    content = re.sub(r'color: (active|isSelected|_saveCard|_editing|lowAtt|atRisk) \? ((?:const )?Color\([^)]+\)|AppColors\.\w+) : Colors\.white', r'color: \1 ? \2 : AppColors.surface', content)
    
    # 2. backgroundColor: Colors.white
    content = re.sub(r'backgroundColor:\s*Colors\.white', r'backgroundColor: AppColors.surface', content)
    
    # 3. fillColor: isReadOnly ? AppColors.background : Colors.white
    content = re.sub(r'fillColor: (isReadOnly) \? AppColors\.background : Colors\.white', r'fillColor: \1 ? AppColors.background : AppColors.surface', content)
    
    # 4. background in general
    content = re.sub(r'color:\s*Colors\.white,(\s*borderRadius:)', r'color: AppColors.surface,\1', content)

    # 5. Fix hardcoded hex Backgrounds that might be white but written as Color(0xFFFFFFFF) or similar white variants
    content = re.sub(r'Color\(0xFFFFFFFF\)', r'AppColors.surface', content)

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Patched {filepath}")

for root, _, files in os.walk(VIEWS_DIR):
    for f in files:
        if f.endswith('.dart'):
            patch_file(os.path.join(root, f))
            
# Also patch app_drawer and notifications_panel
patch_file('lib/widgets/layout/app_drawer.dart')
patch_file('lib/widgets/layout/notifications_panel.dart')
patch_file('lib/widgets/layout/profile_panel.dart')

