from PIL import Image
import os

assets = [
    'assets/images/background2.png',
    'assets/images/background2a.png',
    'assets/images/scene1.png',
    'assets/images/scene1a.png',
    'assets/images/scene1b.png',
    'assets/images/scene1c.png'
]

for asset in assets:
    try:
        with Image.open(asset) as img:
            print(f"{os.path.basename(asset)}: {img.size}")
    except Exception as e:
        print(f"Error opening {asset}: {e}")
