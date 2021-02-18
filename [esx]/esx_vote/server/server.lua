ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('elec:vote')
AddEventHandler('elec:vote', function(candidate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local candidate = candidate
    MySQL.Async.fetchAll(
        'SELECT * FROM vote WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier
        },
        function(result)
          if #result == 0 then
            MySQL.Async.execute(
              'INSERT INTO vote (identifier,candidate) VALUES (@identifier, @candidate)',
              {
                ['@identifier'] = xPlayer.identifier,
                ['@candidate'] = candidate
              },
              function(rowsChanged)
              end
            )

          else
            MySQL.Async.execute(
              'UPDATE vote SET candidate = @candidate WHERE identifier = @identifier',
              {
                ['@identifier']    = xPlayer.identifier,
                ['@candidate']    = candidate
              }
            )
          end

        end
    )
end)