# Adopted from:
# https://github.com/matt1432/nixos-configs/blob/bfe66b139726b453cf44cf87a94f5246a4792679/modules/desktop/environment/modules/packages.nix#L198
{
  glfw3-minecraft,
  fetchpatch,
}:
glfw3-minecraft.overrideAttrs (o: {
  patches =
    o.patches
    ++ [
      (fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0006-Avoid-error-on-startup.patch?h=glfw-wayland-minecraft-cursorfix";
        hash = "sha256-oF+mTNOXPq/yr+y58tTeRkLJE67QzJJSleKFZ85+Uys=";
      })
      (fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-Fix-duplicate-pointer-scroll-events.patch?h=glfw-wayland-minecraft-cursorfix";
        hash = "sha256-qd92eEqXjBPf0mgD19U5H8E88idd6NC6WnRTfvm829w=";
      })
    ];
})
