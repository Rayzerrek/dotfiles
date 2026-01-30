function vim
  if test (count $argv) -eq 0
    nvim .
  else
    nvim $argv
  end
end

function vi
  if test (count $argv) -eq 0
    nvim .
  else
    nvim $argv
  end
end

function magazyn
  cd /c/users/Ziut/desktop/magazyn/frontend
end
