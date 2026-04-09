import os
import re

VIEWS_DIR = 'lib/views'

def patch_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    original = content
    
    # Study plan / Progress screen inline colors:
    # 0xFFF0FDF4 -> AppColors.successSurface
    # 0xFFEFF6FF -> AppColors.infoSurface
    # 0xFFFFFBEB -> AppColors.warningSurface
    # 0xFFFEF2F2 -> AppColors.errorSurface
    # 0xFFBBF7D0 -> AppColors.successLight
    # 0xFFBFDBFE -> AppColors.infoLight
    # Colors.white as fallback in those ternaries -> AppColors.surface
    
    content = content.replace('const Color(0xFFF0FDF4)', 'AppColors.successSurface')
    content = content.replace('const Color(0xFFEFF6FF)', 'AppColors.infoSurface')
    content = content.replace('const Color(0xFFFFFBEB)', 'AppColors.warningSurface')
    content = content.replace('const Color(0xFFFEF2F2)', 'AppColors.errorSurface')
    content = content.replace('Color(0xFFFEF2F2)', 'AppColors.errorSurface')
    
    content = content.replace('const Color(0xFFBBF7D0)', 'AppColors.successLight')
    content = content.replace('const Color(0xFFBFDBFE)', 'AppColors.infoLight')

    content = content.replace('? const Color(0xFFDCFCE7)\n                                    : isInProgress\n                                    ? const Color(0xFFDBEAFE)', '? AppColors.successSurface\n                                    : isInProgress\n                                    ? AppColors.infoSurface')
    content = content.replace('const Color(0xFFDCFCE7)', 'AppColors.successSurface')
    content = content.replace('const Color(0xFFDBEAFE)', 'AppColors.infoSurface')

    content = re.sub(r':\s*Colors\.white;', r': AppColors.surface;', content)

    # _tabButton in progress_screen
    content = re.sub(r'color: isActive \? Colors\.white : Colors\.transparent,', r'color: isActive ? AppColors.surface : Colors.transparent,', content)

    # Chat bubbles: color: isMe ? AppColors.primary : Colors.white
    content = re.sub(r'color: isMe \? AppColors\.primary : Colors\.white', r'color: isMe ? AppColors.primary : AppColors.surface', content)
    
    # Surveys Screen completed card: color: Colors.white
    content = re.sub(r'color:\s*Colors\.white.withValues', r'color: AppColors.surface.withValues', content)
    
    # Text colors that shouldn't be white when active if they are going to dark surface
    # Wait, text should be white if on primary color.
    
    # Edit profile btn in profile_screen: backgroundColor: _editing ? AppColors.primary : Colors.white
    content = re.sub(r'backgroundColor: _editing \? AppColors\.primary : Colors\.white', r'backgroundColor: _editing ? AppColors.primary : AppColors.surface', content)

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Patched {filepath}")

for root, _, files in os.walk(VIEWS_DIR):
    for f in files:
        if f.endswith('.dart'):
            patch_file(os.path.join(root, f))
