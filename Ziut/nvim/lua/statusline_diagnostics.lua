-- lua/statusline_diagnostics.lua
-- ~/.config/nvim/lua/statusline_diagnostics.lua

local M = {}

-- Funkcja do pobierania i formatowania statusu diagnostyki
function M.get_status()
  -- Sprawdza, czy są aktywne klienty LSP w bieżącym buforze
  if vim.tbl_isempty(vim.lsp.get_active_clients()) then
    return ""
  end

  -- Pobieranie licznika diagnostyki dla bieżącego bufora (numer 0)
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  -- Możesz dodać hinty i informacje, jeśli chcesz
  -- local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  -- local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local parts = {}
  
  -- Dodaj błędy (czerwone podświetlenie)
  if errors > 0 then
    -- Użycie higlightu LspDiagnosticsError
    table.insert(parts, "%#LspDiagnosticsError#" .. errors .. " E%*") 
  end

  -- Dodaj ostrzeżenia (żółte podświetlenie)
  if warnings > 0 then
    -- Użycie higlightu LspDiagnosticsWarning
    table.insert(parts, "%#LspDiagnosticsWarning#" .. warnings .. " W%*")
  end

  if #parts > 0 then
    -- Łączenie części i dodanie spacji
    return " | " .. table.concat(parts, " ") .. " "
  else
    -- Jeśli nie ma diagnostyki, wyświetl OK
    return " | OK "
  end
end

return M
