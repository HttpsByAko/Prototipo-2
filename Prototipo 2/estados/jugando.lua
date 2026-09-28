require("estados/estado")


EstadoJugando = {}


------------------------------------------------
-- CREAR ESTADO
------------------------------------------------

function EstadoJugando:nuevo(
    jugador,
    sala,
    maquinaEstado,
    estadoGameOver
)

    local estado = Estado:nuevo()


    estado.jugador = jugador
    estado.sala = sala

    estado.maquinaEstado =
        maquinaEstado

    estado.estadoGameOver =
        estadoGameOver

    estado.enemigos = {}

    estado.ronda = 0
    estado.numeroSala = 0


    setmetatable(
        estado,
        {
            __index = EstadoJugando
        }
    )


    return estado

end


------------------------------------------------
-- CREAR ENEMIGOS
------------------------------------------------

function EstadoJugando:crearEnemigos(cantidad)

    self.enemigos = {}


    for i = 1, cantidad do

        local x
        local y

        local posicionEncontrada = false

        local intentos = 0


        while not posicionEncontrada
        and intentos < 200 do

            intentos = intentos + 1


            x = math.random(
                40 + 32,
                love.graphics.getWidth() -
                40 - 32
            )


            y = math.random(
                40 + 32,
                love.graphics.getHeight() -
                40 - 32
            )


            ----------------------------------------
            -- COMPROBAR OBSTÁCULOS
            ----------------------------------------

            local posicionValida =
                Generador:posicionValida(
                    x,
                    y,
                    32,
                    self.sala.obstaculos
                )


            ----------------------------------------
            -- COMPROBAR OTROS ENEMIGOS
            ----------------------------------------

            if posicionValida then

                if Generador:colisionaEnemigos(
                    x,
                    y,
                    32,
                    self.enemigos,
                    nil
                ) then

                    posicionValida = false

                end

            end


            ----------------------------------------
            -- DISTANCIA AL JUGADOR
            ----------------------------------------

            if posicionValida then

                local distanciaX =
                    x - self.jugador.x

                local distanciaY =
                    y - self.jugador.y


                local distancia =
                    math.sqrt(
                        distanciaX * distanciaX +
                        distanciaY * distanciaY
                    )


                local distanciaMinima = 250


                if distancia < distanciaMinima then

                    posicionValida = false

                end

            end


            ----------------------------------------
            -- POSICIÓN ENCONTRADA
            ----------------------------------------

            if posicionValida then

                posicionEncontrada = true

            end

        end


        ----------------------------------------
        -- CREAR ENEMIGO
        ----------------------------------------

        if posicionEncontrada then

            local enemigo =
                Enemigo:nuevo(
                    x,
                    y
                )


            table.insert(
                self.enemigos,
                enemigo
            )

        end

    end

end


------------------------------------------------
-- CREAR NUEVA RONDA
------------------------------------------------

function EstadoJugando:nuevaRonda()

    self.ronda =
        self.ronda + 1


    ----------------------------------------
    -- CAMBIAR GENERACIÓN CADA 3 RONDAS
    ----------------------------------------

    if self.ronda == 1
    or (self.ronda - 1) % 3 == 0 then

        self.numeroSala =
            self.numeroSala + 1


        self.sala.obstaculos =
            Generador:crearObstaculos(
                self.jugador.x,
                self.jugador.y
            )

    end


    ----------------------------------------
    -- CANTIDAD DE ENEMIGOS
    ----------------------------------------

    local cantidadEnemigos =
        2 + self.ronda


    self:crearEnemigos(
        cantidadEnemigos
    )

end


------------------------------------------------
-- ENTRAR AL ESTADO
------------------------------------------------

function EstadoJugando:entrar()

    self:nuevaRonda()

end


------------------------------------------------
-- SALIR DEL ESTADO
------------------------------------------------

function EstadoJugando:salir()

end


------------------------------------------------
-- ACTUALIZAR
------------------------------------------------

function EstadoJugando:actualizar(dt)

    ----------------------------------------
    -- COMPROBAR SI EL JUGADOR MURIÓ
    ----------------------------------------

    if self.jugador.vida <= 0 then

        self.maquinaEstado:cambiar(
            self.estadoGameOver
        )

        return

    end


    ----------------------------------------
    -- ACTUALIZAR JUGADOR
    ----------------------------------------

    self.jugador:actualizar(
        dt,
        self.sala.obstaculos
    )


    ----------------------------------------
    -- ACTUALIZAR ENEMIGOS
    ----------------------------------------

    for i, enemigo in ipairs(self.enemigos) do

        enemigo:actualizar(
            dt,
            self.jugador,
            self.sala.obstaculos,
            self.enemigos
        )

    end


    ----------------------------------------
    -- COMPROBAR SI EL JUGADOR MURIÓ
    ----------------------------------------

    if self.jugador.vida <= 0 then

        self.maquinaEstado:cambiar(
            self.estadoGameOver
        )

        return

    end


    ----------------------------------------
    -- ELIMINAR ENEMIGOS MUERTOS
    ----------------------------------------

    for i = #self.enemigos, 1, -1 do

        if self.enemigos[i]:estaMuerto() then

            table.remove(
                self.enemigos,
                i
            )

        end

    end


    ----------------------------------------
    -- COMPROBAR FIN DE RONDA
    ----------------------------------------

    if #self.enemigos == 0 then

        self:nuevaRonda()

    end

end


------------------------------------------------
-- DIBUJAR
------------------------------------------------

function EstadoJugando:dibujar()

    ----------------------------------------
    -- SALA
    ----------------------------------------

    self.sala:dibujar()


    ----------------------------------------
    -- ENEMIGOS
    ----------------------------------------

    for i, enemigo in ipairs(self.enemigos) do

        enemigo:dibujar()

    end


    ----------------------------------------
    -- JUGADOR
    ----------------------------------------

    self.jugador:dibujar()


    ----------------------------------------
    -- INFORMACIÓN
    ----------------------------------------

    love.graphics.setColor(
        1,
        1,
        1
    )


    love.graphics.print(
        "RONDA: " .. self.ronda,
        20,
        15,
        0,
        2,
        2
    )


    love.graphics.print(
        "ENEMIGOS: " .. #self.enemigos,
        20,
        45,
        0,
        1.5,
        1.5
    )


    love.graphics.print(
        "SALA: " .. self.numeroSala,
        20,
        70,
        0,
        1.5,
        1.5
    )

end


------------------------------------------------
-- ATAQUE
------------------------------------------------

function EstadoJugando:atacar()

    self.jugador:atacar(
        self.enemigos
    )

end