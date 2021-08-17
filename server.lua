ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local players = {}

ESX.RegisterServerCallback("tgiann-mdtv2:ilk-data", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT firstname, lastname, job FROM users WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function (result)
        if result[1] then
            cb(players, ESX.Items, result[1].firstname.." "..result[1].lastname)
        end
    end)
end)

Citizen.CreateThread(function()
    MySQL.Async.fetchAll("SELECT firstname, lastname, job FROM users ", {
    }, function (result)
        players.police = {}
        players.user = {}
        for i=1, #result do
            if result[i].job == "police" then
                table.insert(players.police, result[i].firstname .. " " .. result[i].lastname)
            else
                table.insert(players.user, result[i].firstname .. " " .. result[i].lastname)
            end
        end
    end) 
end)

RegisterCommand("mdt", function(source, args)
	TriggerClientEvent('tgiann-mdtv2:open', source)
end)

ESX.RegisterServerCallback("tgiann-mdtv2:sorgula", function(source, cb, data)
    if data.tip == "isim" then
        MySQL.Async.fetchAll("SELECT * FROM users WHERE CONCAT(firstname, ' ', lastname) LIKE @search LIMIT 30", {
            ['@search'] = '%'..data.data..'%'
        }, function (result)
            if result then
                cb(result)
            end
        end) 
    elseif data.tip == "arac" then
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {
            ['@owner'] = data.data
        }, function (result)
            if result then
                cb(result)
            end
        end) 
    elseif data.tip == "numara" then
        MySQL.Async.fetchAll("SELECT * FROM users WHERE phone_number LIKE @search LIMIT 30", {
            ['@search'] = '%'..data.data..'%'
        }, function (result)
            if result then
                cb(result)
            end
        end) 
    elseif data.tip == "plaka" then
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles LEFT JOIN users ON owned_vehicles.owner = users.identifier WHERE owned_vehicles.plate LIKE @plate LIMIT 30", {
            ['@plate'] = '%'..data.data..'%'
        }, function (result)
            if result then
                cb(result)
            end
        end) 
    end
end)

ESX.RegisterServerCallback("tgiann-mdtv2:photo", function(source, cb, data)
    MySQL.Async.fetchAll("SELECT photo FROM users WHERE identifier = @identifier", {
        ['@identifier'] = data.data
    }, function (result)
        if result then
            cb(result[1].photo)
        end
    end) 
end)

RegisterServerEvent('tgiann-mdtv2:ceza-kaydet')
AddEventHandler('tgiann-mdtv2:ceza-kaydet', function(data)
    local src = source
    MySQL.Async.fetchAll("INSERT INTO tgiann_mdt_olaylar SET aciklama = @aciklama, polis = @polis, zanli = @zanli, esyalar = @esyalar", {
        ["@aciklama"] = data.aciklama,
        ["@polis"] = json.encode(data.polis),
        ["@zanli"] = json.encode(data.zanli),
        ["@esyalar"] = json.encode(data.esyalar),
     }, function(result1)
        for i=1, #data.zanli do
            MySQL.Async.fetchAll("SELECT identifier FROM users WHERE CONCAT(firstname, ' ', lastname) LIKE @search LIMIT 30", {
                ['@search'] = '%'..data.zanli[i]..'%'
            }, function(result)
                if result[1] then
                   --[[  if data.illegal then
                        local tPlayer = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
                        if tPlayer and not tPlayer.PlayerData.metadata.illegalv2 then
                            tPlayer.Functions.SetMetaData("illegalv2", true)
                            TriggerClientEvent("tgiann-base:set-illegal", tPlayer.PlayerData.source, QBCore.Key)
                        end
                    end ]]

                    --[[ if data.ceza.tceza > 0 then
                        local tPlayer = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
                        if tPlayer and tPlayer.PlayerData.metadata.ehliyetceza < 10 then
                            local newValue = tPlayer.PlayerData.metadata.ehliyetceza+data.ceza.tceza
                            tPlayer.Functions.SetMetaData("ehliyetceza", newValue)
                            if newValue > 9 then
                                TriggerClientEvent("QBCore:Notify", tPlayer.PlayerData.source, "Ehliyetine Polis Tarafından El Konuldu", "error", 15000)
                                TriggerClientEvent("QBCore:Notify", src, tPlayer.PlayerData.charinfo.firstname.. " " ..tPlayer.PlayerData.charinfo.lastname.." İsimli Kişinin Ehliyetine El Konuldu", "success", 15000)
                            end
                        end
                    end ]]
                    
                    MySQL.Async.fetchAll("INSERT INTO tgiann_mdt_cezalar SET citizenid = @citizenid, aciklama = @aciklama, ceza = @ceza, polis = @polis, cezalar = @cezalar, zanli = @zanli, olayid = @id", {
                        ["@citizenid"] = result[1].identifier,
                        ["@aciklama"] = data.aciklama,
                        ["@ceza"] = json.encode(data.ceza),
                        ["@polis"] = json.encode(data.polis),
                        ["@zanli"] = json.encode(data.zanli),
                        ["@cezalar"] = data.cezaisim,
                        ["@id"] = result1.insertId
                    })
                end
            end)
        end
    end)
end)

ESX.RegisterServerCallback("tgiann-mdtv2:olaylardata", function(source, cb, data)
    MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_olaylar ORDER BY id DESC LIMIT 100", {
    }, function (result)
        cb(result)
    end) 
end)

ESX.RegisterServerCallback("tgiann-mdtv2:sabikadata", function(source, cb, data)
    MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_cezalar WHERE citizenid = @citizenid ORDER BY id DESC ", {
        ["@citizenid"] = data
    }, function (result)
        cb(result)
    end) 
end)

RegisterServerEvent('tgiann-mdtv2:sabikasil')
AddEventHandler('tgiann-mdtv2:sabikasil', function(data)
    MySQL.Async.fetchAll("DELETE FROM tgiann_mdt_cezalar WHERE id = @id", {
        ['@id'] = data
    })
end)

RegisterServerEvent('tgiann-mdtv2:setavatar')
AddEventHandler('tgiann-mdtv2:setavatar', function(url, id)
    MySQL.Async.fetchAll("UPDATE users SET photo=@photo WHERE identifier = @identifier", {
        ['@identifier'] = id,
        ['@photo'] = url
    })
end)

RegisterServerEvent('tgiann-mdtv2:olaysil')
AddEventHandler('tgiann-mdtv2:olaysil', function(id)
    MySQL.Async.fetchAll("DELETE FROM tgiann_mdt_olaylar WHERE id = @id", {
        ['@id'] = id
    })
    MySQL.Async.fetchAll("DELETE FROM tgiann_mdt_cezalar WHERE olayid = @olayid", {
        ['@olayid'] = id
    })
end)

RegisterServerEvent('tgiann-mdtv2:aranma')
AddEventHandler('tgiann-mdtv2:aranma', function(data, durum)
    if durum then
        local saat = os.time() + data.saat * 86400
        MySQL.Async.fetchAll("UPDATE users SET aranma=@aranma WHERE identifier = @identifier", {
            ['@identifier'] = data.id,
            ['@aranma'] = json.encode({durum = true, sebep=data.neden, suansaat=os.time(), saat=saat})
        })

        MySQL.Async.fetchAll("INSERT INTO tgiann_mdt_arananlar SET citizenid = @citizenid, sebep = @sebep, baslangic = @baslangic, bitis = @bitis, isim = @isim", {
            ["@citizenid"] = data.id,
            ["@sebep"] = data.neden,
            ["@baslangic"] = os.time(),
            ["@bitis"] = saat,
            ["@isim"] = data.isim
        })
    else
        MySQL.Async.fetchAll("UPDATE users SET aranma=@aranma WHERE identifier = @identifier", {
            ['@identifier'] = data.id,
            ['@aranma'] = json.encode({durum = false, sebep="", suansaat="", saat=""})
        })
        
        MySQL.Async.fetchAll("DELETE FROM tgiann_mdt_arananlar WHERE citizenid = @citizenid", {
            ['@citizenid'] = data.id
        })
    end
end)

ESX.RegisterServerCallback("tgiann-mdtv2:arananlar", function(source, cb, data)
    MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_arananlar", {
    }, function (result)
        cb(result)
    end) 
end)

ESX.RegisterServerCallback("tgiann-mdtv2:olayara", function(source, cb, data)
    MySQL.Async.fetchAll("SELECT * FROM tgiann_mdt_olaylar WHERE id = @id", {
        ["@id"] = tonumber(data)
    }, function (result)
        cb(result)
    end) 
end)