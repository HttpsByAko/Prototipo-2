Generador = {}


------------------------------------------------
-- CREAR OBSTÁCULOS
------------------------------------------------

function Generador:crearObstaculos(jugadorX, jugadorY)

    local obstaculos = {}

    local cantidad = 6

    local grosorSala = 40

    local anchoPantalla = love.graphics.getWidth()
    local altoPantalla = love.graphics.getHeight()

    local intentos = 0


    while #obstaculos < cantidad
    and intentos < 100 do

        intentos = intentos + 1

        local obstaculo = {}

        obstaculo.ancho =
            math.random(80, 180)

        obstaculo.alto =
            math.random(40, 100)


        obstaculo.x =
            math.random(
                grosorSala +
                    obstaculo.ancho / 2,
                anchoPantalla -
                    grosorSala -
                    obstaculo.ancho / 2
            )


        obstaculo.y =
            math.random(
                grosorSala +
                    obstaculo.alto / 2,
                altoPantalla -
                    grosorSala -
                    obstaculo.alto / 2
            )


        ----------------------------------------
        -- DISTANCIA CON EL JUGADOR
        ----------------------------------------

        local distanciaX =
            obstaculo.x - jugadorX

        local distanciaY =
            obstaculo.y - jugadorY


        local distancia =
            math.sqrt(
                distanciaX * distanciaX +
                distanciaY * distanciaY
            )


        local distanciaMinima = 150


        ----------------------------------------
        -- COMPROBAR SUPERPOSICIÓN
        ----------------------------------------

        local seSuperpone = false


        for i, otro in ipairs(obstaculos) do

            local izquierda =
                obstaculo.x -
                obstaculo.ancho / 2

            local derecha =
                obstaculo.x +
                obstaculo.ancho / 2

            local arriba =
                obstaculo.y -
                obstaculo.alto / 2

            local abajo =
                obstaculo.y +
                obstaculo.alto / 2


            local otraIzquierda =
                otro.x -
                otro.ancho / 2

            local otraDerecha =
                otro.x +
                otro.ancho / 2

            local otraArriba =
                otro.y -
                otro.alto / 2

            local otraAbajo =
                otro.y +
                otro.alto / 2


            if derecha > otraIzquierda
            and izquierda < otraDerecha
            and abajo > otraArriba
            and arriba < otraAbajo then

                seSuperpone = true

                break

            end

        end


        ----------------------------------------
        -- AGREGAR OBSTÁCULO
        ----------------------------------------

        if distancia >= distanciaMinima
        and not seSuperpone then

            table.insert(
                obstaculos,
                obstaculo
            )

        end

    end


    return obstaculos

end


------------------------------------------------
-- COMPROBAR POSICIÓN
------------------------------------------------

function Generador:posicionValida(
    x,
    y,
    tamaño,
    obstaculos
)

    for i, obstaculo in ipairs(obstaculos) do

        local izquierda =
            obstaculo.x -
            obstaculo.ancho / 2

        local derecha =
            obstaculo.x +
            obstaculo.ancho / 2

        local arriba =
            obstaculo.y -
            obstaculo.alto / 2

        local abajo =
            obstaculo.y +
            obstaculo.alto / 2


        if x + tamaño / 2 > izquierda
        and x - tamaño / 2 < derecha
        and y + tamaño / 2 > arriba
        and y - tamaño / 2 < abajo then

            return false

        end

    end


    return true

end


------------------------------------------------
-- COMPROBAR COLISIÓN CON OBSTÁCULOS
------------------------------------------------

function Generador:colisiona(
    x,
    y,
    tamaño,
    obstaculos
)

    for i, obstaculo in ipairs(obstaculos) do

        local izquierda =
            obstaculo.x -
            obstaculo.ancho / 2

        local derecha =
            obstaculo.x +
            obstaculo.ancho / 2

        local arriba =
            obstaculo.y -
            obstaculo.alto / 2

        local abajo =
            obstaculo.y +
            obstaculo.alto / 2


        if x + tamaño / 2 > izquierda
        and x - tamaño / 2 < derecha
        and y + tamaño / 2 > arriba
        and y - tamaño / 2 < abajo then

            return true

        end

    end


    return false

end


------------------------------------------------
-- COMPROBAR COLISIÓN CON ENEMIGOS
------------------------------------------------

function Generador:colisionaEnemigos(
    x,
    y,
    tamaño,
    enemigos,
    enemigoActual
)

    for i, enemigo in ipairs(enemigos) do

        if enemigo ~= enemigoActual then

            local distanciaX =
                x - enemigo.x

            local distanciaY =
                y - enemigo.y


            local distancia =
                math.sqrt(
                    distanciaX * distanciaX +
                    distanciaY * distanciaY
                )


            local distanciaMinima =
                tamaño / 2 +
                enemigo.tamaño / 2


            if distancia < distanciaMinima then

                return true

            end

        end

    end


    return false

end


------------------------------------------------
-- COMPROBAR COLISIÓN CON JUGADOR
------------------------------------------------

function Generador:colisionaJugador(
    x,
    y,
    tamaño,
    jugador
)

    local distanciaX =
        x - jugador.x

    local distanciaY =
        y - jugador.y


    local distancia =
        math.sqrt(
            distanciaX * distanciaX +
            distanciaY * distanciaY
        )


    local distanciaMinima =
        tamaño / 2 +
        jugador.tamaño / 2


    if distancia < distanciaMinima then

        return true

    end


    return false

end