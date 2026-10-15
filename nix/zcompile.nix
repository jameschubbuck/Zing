# Byte-compile a zsh plugin at build time
# zsh prefers foo.zsh.zwc if not older, and store paths share one timestamp
# Copies the whole package, as plugins find their pieces via `${0:A:h}`
{
  runCommandLocal,
  zsh,
}: pkg:
runCommandLocal "${pkg.name}-zwc" {} ''
  cp -r ${pkg} $out
  chmod -R u+w $out
  find $out -name '*.zsh' \
    -exec ${zsh}/bin/zsh -fc 'zcompile -R -- "$1"' zsh {} \;
''
