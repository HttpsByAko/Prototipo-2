Sala = {}


function Sala:nuevo()

    local sala = {}

    sala.ancho = love.graphics.getWidth()
    sala.alto = love.graphics.getHeight()

    sala.grosor = 40

    sala.obstaculos = {}

    setmetatable(sala, { __index = Sala })

    return sala

end


function Sala:dibujar()

    local ancho = self.ancho
    local alto = self.alto
    local grosor = self.grosor


    -- Suelo

    love.graphics.setColor(0.08, 0.08, 0.08)

    love.graphics.rectangle(
        "fill",
        grosor,
        grosor,
        ancho - grosor * 2,
        alto - grosor * 2
    )


    -- Paredes

    love.graphics.setColor(0.25, 0.25, 0.25)


    -- Arriba

    love.graphics.rectangle(
        "fill",
        0,
        0,
        ancho,
        grosor
    )


    -- Abajo

    love.graphics.rectangle(
        "fill",
        0,
        alto - grosor,
        ancho,
        grosor
    )


    -- Izquierda

    love.graphics.rectangle(
        "fill",
        0,
        0,
        grosor,
        alto
    )


    -- Derecha

    love.graphics.rectangle(
        "fill",
        ancho - grosor,
        0,
        grosor,
        alto
    )


    -- Obstáculos

    love.graphics.setColor(0.20, 0.20, 0.20)


    for i, obstaculo in ipairs(self.obstaculos) do

        love.graphics.rectangle(
            "fill",
            obstaculo.x - obstaculo.ancho / 2,
            obstaculo.y - obstaculo.alto / 2,
            obstaculo.ancho,
            obstaculo.alto
        )

    end

end