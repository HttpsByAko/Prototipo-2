Enemigo = {}


------------------------------------------------
-- CREAR ENEMIGO
------------------------------------------------

function Enemigo:nuevo(x, y)

    local enemigo = {}

    enemigo.x = x
    enemigo.y = y

    enemigo.tamaño = 32

    enemigo.velocidad = 100

    enemigo.vida = 2

    enemigo.daño = 1


    setmetatable(
        enemigo,
        {
            __index = Enemigo
        }
    )

    return enemigo

end


------------------------------------------------
-- RECIBIR DAÑO
------------------------------------------------

function Enemigo:recibirDaño(daño)

    self.vida =
        self.vida - daño

end


------------------------------------------------
-- COMPROBAR SI ESTÁ MUERTO
------------------------------------------------

function Enemigo:estaMuerto()

    return self.vida <= 0

end


------------------------------------------------
-- COMPROBAR COLISIÓN CON JUGADOR
------------------------------------------------

function Enemigo:colisionaConJugador(jugador)

    local distanciaX =
        jugador.x - self.x

    local distanciaY =
        jugador.y - self.y


    local distancia =
        math.sqrt(
            distanciaX * distanciaX +
            distanciaY * distanciaY
        )


    local distanciaMinima =
        self.tamaño / 2 +
        jugador.tamaño / 2


    return distancia < distanciaMinima

end


------------------------------------------------
-- ACTUALIZAR
------------------------------------------------

function Enemigo:actualizar(
    dt,
    jugador,
    obstaculos,
    enemigos
)

    local direccionX =
        jugador.x - self.x

    local direccionY =
        jugador.y - self.y


    local distancia =
        math.sqrt(
            direccionX * direccionX +
            direccionY * direccionY
        )


    if distancia > 0 then

        direccionX =
            direccionX / distancia

        direccionY =
            direccionY / distancia


        ----------------------------------------
        -- MOVIMIENTO HORIZONTAL
        ----------------------------------------

        local nuevoX =
            self.x +
            direccionX *
            self.velocidad *
            dt


        local chocaObstaculo =
            Generador:colisiona(
                nuevoX,
                self.y,
                self.tamaño,
                obstaculos
            )


        local chocaEnemigo =
            Generador:colisionaEnemigos(
                nuevoX,
                self.y,
                self.tamaño,
                enemigos,
                self
            )


        local chocaJugador =
            Generador:colisionaJugador(
                nuevoX,
                self.y,
                self.tamaño,
                jugador
            )


        if not chocaObstaculo
        and not chocaEnemigo
        and not chocaJugador then

            self.x = nuevoX

        end


        ----------------------------------------
        -- MOVIMIENTO VERTICAL
        ----------------------------------------

        local nuevoY =
            self.y +
            direccionY *
            self.velocidad *
            dt


        chocaObstaculo =
            Generador:colisiona(
                self.x,
                nuevoY,
                self.tamaño,
                obstaculos
            )


        chocaEnemigo =
            Generador:colisionaEnemigos(
                self.x,
                nuevoY,
                self.tamaño,
                enemigos,
                self
            )


        chocaJugador =
            Generador:colisionaJugador(
                self.x,
                nuevoY,
                self.tamaño,
                jugador
            )


        if not chocaObstaculo
        and not chocaEnemigo
        and not chocaJugador then

            self.y = nuevoY

        end

    end


    ----------------------------------------
    -- DAÑO AL JUGADOR
    ----------------------------------------

    if self:colisionaConJugador(jugador) then

        jugador:recibirDaño(
            self.daño
        )

    end

end


------------------------------------------------
-- DIBUJAR
------------------------------------------------

function Enemigo:dibujar()

    ----------------------------------------
    -- ENEMIGO
    ----------------------------------------

    love.graphics.setColor(
        0.8,
        0.15,
        0.15
    )


    love.graphics.rectangle(
        "fill",
        self.x - self.tamaño / 2,
        self.y - self.tamaño / 2,
        self.tamaño,
        self.tamaño
    )


    ----------------------------------------
    -- VIDA
    ----------------------------------------

    love.graphics.setColor(
        0.1,
        0.1,
        0.1
    )


    love.graphics.rectangle(
        "fill",
        self.x - 20,
        self.y - 28,
        40,
        5
    )


    love.graphics.setColor(
        0.2,
        0.9,
        0.2
    )


    love.graphics.rectangle(
        "fill",
        self.x - 20,
        self.y - 28,
        20 * self.vida,
        5
    )

end