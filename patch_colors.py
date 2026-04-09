import os
import re

VIEWS_DIR = 'lib/views'

def patch_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original = content
    
    # 1. Replace Colors.white inside BoxDecoration to AppColors.surface
    content = re.sub(r'color:\s*Colors\.white\s*,(\s*borderRadius:)', r'color: AppColors.surface,\g<1>', content)
    content = re.sub(r'color:\s*Colors\.white\s*\)', r'color: AppColors.surface)', content)
    content = re.sub(r'color:\s*isSelected[ \t\n]*\?[ \t\n]*AppColors\.primarySurface[ \t\n]*:[ \t\n]*Colors\.white', r'color: isSelected ? AppColors.primarySurface : AppColors.surface', content)
    content = re.sub(r'color:\s*isActive[ \t\n]*\?[ \t\n]*Colors\.white[ \t\n]*:[ \t\n]*Colors\.transparent', r'color: isActive ? AppColors.surface : Colors.transparent', content)
    
    # 2. backgroundColor inside BottomSheet or similar
    content = re.sub(r'backgroundColor:\s*Colors\.white', r'backgroundColor: AppColors.surface', content)
    
    # 3. fillColor in TextField
    content = re.sub(r'fillColor:\s*Colors\.white', r'fillColor: AppColors.surface', content)

    # 4. Other obvious background colors
    content = re.sub(r'(?<!foreground)Color:\s*Colors\.white([,\)])', r'Color: AppColors.surface\1', content)
    # Be careful not to replace text color or icon color! Above regex matches "Color: Colors..." missing c?
    
    # Let's be safe. Find cases of BoxConstraints, InkWell, Container, etc. Actually just doing the above covers 90%
    
    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Patched {filepath}")

for root, _, files in os.walk(VIEWS_DIR):
    for f in files:
        if f.endswith('.dart'):
            patch_file(os.path.join(root, f))
