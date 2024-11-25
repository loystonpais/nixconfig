{ lib, ... }:
{
	programs.zsh.oh-my-zsh.theme = lib.mkForce "crunch";
}
