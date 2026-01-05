import os
from PIL import Image

assets_dir = r'd:\TECH\TRAINING\UMAI-TABAHASA\flame_game_project\assets\images'
files = ['background.png', 'dialog.png', 'hi.png']

for f in files:
    path = os.path.join(assets_dir, f)
    if os.path.exists(path):
        try:
            with Image.open(path) as img:
                print(f"{f}: {img.size}")
        except Exception as e:
            print(f"{f}: Error {e}")
    else:
        print(f"{f}: Not found")
