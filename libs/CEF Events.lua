addEventHandler('onReceivePacket', function (id, bs) 
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if (raknetBitStreamReadInt8(bs) == 17) then
            raknetBitStreamIgnoreBits(bs, 32)
            array.onDisplayCEF(raknetBitStreamReadString(bs, raknetBitStreamReadInt32(bs)))
        end
    end
end)

addEventHandler('onSendPacket', function (id, bs, priority, reliability, orderingChannel) 
    if id == 220 then
        local id = raknetBitStreamReadInt8(bs)
        local packettype = raknetBitStreamReadInt8(bs)
        local strlen = raknetBitStreamReadInt8(bs)
        raknetBitStreamIgnoreBits(bs, 24)
        local str = raknetBitStreamReadString(bs, strlen)
        if packettype ~= 0 and packettype ~= 1 and #str > 2 then
            array.onSendCEF(str)
        end
    end
end)

array = {}
array.onDisplayCEF = function(array) return array end
array.onSendCEF = function(array) return array end
array.emulationCEF = function(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 220)
    raknetBitStreamWriteInt8(bs, 18)
    raknetBitStreamWriteInt32(bs, #str)
    raknetBitStreamWriteString(bs, str)
    raknetBitStreamWriteInt32(bs, 0)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end
array.visualCEF = function(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 17)
    raknetBitStreamWriteInt32(bs, 0)
    raknetBitStreamWriteInt32(bs, #str)
    raknetBitStreamWriteString(bs, str)
    raknetEmulPacketReceiveBitStream(220, bs)
    raknetDeleteBitStream(bs)
end
return array