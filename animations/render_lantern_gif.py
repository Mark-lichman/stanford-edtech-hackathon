from math import sin, pi
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


S = 4
W, H = 66 * S, 82 * S
BG = "#F5E9CF"
INK = "#3A2E1F"
LAMP = "#E09612"
DIM = "#7A6748"


def lerp(a, b, t):
    return a + (b - a) * t


def color_lerp(a, b, t):
    a = tuple(int(a[i : i + 2], 16) for i in (1, 3, 5))
    b = tuple(int(b[i : i + 2], 16) for i in (1, 3, 5))
    return "#" + "".join(f"{round(lerp(a[i], b[i], t)):02x}" for i in range(3))


def ease(t):
    # Smooth approximation of the CSS cubic-bezier used by the source.
    return t * t * (3 - 2 * t)


def cubic(p0, p1, p2, p3, t):
    u = 1 - t
    return (
        u**3 * p0[0] + 3 * u * u * t * p1[0] + 3 * u * t * t * p2[0] + t**3 * p3[0],
        u**3 * p0[1] + 3 * u * u * t * p1[1] + 3 * u * t * t * p2[1] + t**3 * p3[1],
    )


def flame_points(scale_y):
    # The flame path from the source SVG, sampled as cubic curves.
    parts = [
        ((33, 36), (40, 44), (42, 48), (42, 53)),
        ((42, 53), (42, 58), (38, 62), (33, 62)),
        ((33, 62), (28, 62), (24, 58), (24, 53)),
        ((24, 53), (24, 48), (26, 44), (33, 36)),
    ]
    pts = []
    for p0, p1, p2, p3 in parts:
        for i in range(13):
            x, y = cubic(p0, p1, p2, p3, i / 12)
            y = 53 + (y - 53) * scale_y
            pts.append((round(x * S), round(y * S)))
    return pts


def render(flame_alpha, flame_scale, flame_color, glow_alpha, glow_scale):
    base = Image.new("RGBA", (W, H), BG)

    if glow_alpha > 0:
        glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow)
        r = 15 * S * glow_scale
        cx, cy = 33 * S, 48 * S
        gd.ellipse((cx - r, cy - r, cx + r, cy + r), fill=(*tuple(int(LAMP[i : i + 2], 16) for i in (1, 3, 5)), round(255 * glow_alpha)))
        glow = glow.filter(ImageFilter.GaussianBlur(5 * S))
        base.alpha_composite(glow)

    d = ImageDraw.Draw(base)
    line = max(1, 3 * S)
    d.line([(26 * S, 8 * S), (40 * S, 8 * S)], fill=INK, width=line, joint="curve")
    d.line([(33 * S, 8 * S), (33 * S, 17 * S)], fill=INK, width=line)
    d.rounded_rectangle((14 * S, 17 * S, 52 * S, 26 * S), radius=3 * S, fill=INK)
    body = [(17 * S, 26 * S), (49 * S, 26 * S), (53 * S, 66 * S), (49 * S, 70 * S), (17 * S, 70 * S), (13 * S, 66 * S)]
    d.polygon(body, fill=BG)
    d.line(body + [body[0]], fill=INK, width=line, joint="curve")

    if flame_alpha > 0:
        flame = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        fd = ImageDraw.Draw(flame)
        rgba = (*tuple(int(flame_color[i : i + 2], 16) for i in (1, 3, 5)), round(255 * flame_alpha))
        fd.polygon(flame_points(flame_scale), fill=rgba)
        base.alpha_composite(flame)

    d = ImageDraw.Draw(base)
    d.rounded_rectangle((9 * S, 70 * S, 57 * S, 78 * S), radius=4 * S, fill=INK)
    return base.convert("RGB")


def main():
    frames = []
    fps = 15

    # Match the source timing: 2.8s glow-on, 0.7s hold, 0.52s fade, 0.8s dark.
    for i in range(round(2.8 * fps)):
        t = ease(i / (2.8 * fps - 1))
        frames.append(render(t, lerp(0.35, 1.0, t), color_lerp(DIM, LAMP, t), 0.4 * t, lerp(0.4, 1.0, t)))
    frames.extend([render(1, 1, LAMP, 0.4, 1)] * round(0.7 * fps))

    for i in range(round(0.52 * fps)):
        raw = i / (0.52 * fps - 1)
        t = ease(raw)
        pulse = min(raw / 0.22, 1.0)
        if raw <= 0.22:
            flame_alpha, flame_scale, glow_alpha, glow_scale = 1.0, lerp(1, 1.18, ease(pulse)), lerp(0.4, 0.62, ease(pulse)), lerp(1, 1.15, ease(pulse))
        else:
            fade = ease((raw - 0.22) / 0.78)
            flame_alpha, flame_scale, glow_alpha, glow_scale = 1 - fade, lerp(1.18, 0.25, fade), lerp(0.62, 0, fade), lerp(1.15, 0.3, fade)
        frames.append(render(flame_alpha, flame_scale, color_lerp(LAMP, DIM, t), glow_alpha, glow_scale))
    frames.extend([render(0, 0.25, DIM, 0, 0.3)] * round(0.8 * fps))

    out = Path(__file__).resolve().parents[1] / "output" / "lantern-animation.gif"
    out.parent.mkdir(exist_ok=True)
    frames[0].save(out, save_all=True, append_images=frames[1:], duration=round(1000 / fps), loop=0, disposal=2, optimize=False)
    print(out)


if __name__ == "__main__":
    main()
