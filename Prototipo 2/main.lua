require("jugador")
require("sala")
require("generador")
require("enemigo")

require("estados/estado")
require("estados/maquinaEstado")
require("estados/jugando")
require("estados/gameOver")


local jugador
local sala
local maquinaEstado


------------------------------------------------
-- INICIAR JUEGO
------------------------------------------------

function love.load()

    love.graphics.setBackgroundColor(
        0.05,
        0.05,
        0.05
    )


    ------------------------------------------------
    -- CREAR SALA
    ------------------------------------------------

    sala = Sala:nuevo()


    ------------------------------------------------
    -- CREAR JUGADOR
    ------------------------------------------------

    jugador = {}

    setmetatable(
        jugador,
        {
            __index = Jugador
        }
    )

    jugador:nuevo()


    ------------------------------------------------
    -- CREAR MÁQUINA DE ESTADOS
    ------------------------------------------------

    maquinaEstado =
        MaquinaEstado:nuevo()


    ------------------------------------------------
    -- CREAR ESTADO JUGANDO
    ------------------------------------------------

    local jugando


    ------------------------------------------------
    -- CREAR GAME OVER
    ------------------------------------------------

    local gameOver


    ----------------------------------------
    -- CREAR ESTADO JUGANDO
    ----------------------------------------

    jugando =
        EstadoJugando:nuevo(
            jugador,
            sala,
            maquinaEstado,
            nil
        )


    ----------------------------------------
    -- CREAR ESTADO GAME OVER
    ----------------------------------------

    gameOver =
        EstadoGameOver:nuevo(
            maquinaEstado,
            jugando
        )


    ----------------------------------------
    -- CONECTAR GAME OVER CON JUGANDO
    ----------------------------------------

    jugando.estadoGameOver =
        gameOver


    ----------------------------------------
    -- INICIAR EN JUGANDO
    ----------------------------------------

    maquinaEstado:cambiar(
        jugando
    )

end


------------------------------------------------
-- ACTUALIZAR
------------------------------------------------

function love.update(dt)

    maquinaEstado:actualizar(
        dt
    )

end


------------------------------------------------
-- TECLA PRESIONADA
------------------------------------------------

function love.keypressed(tecla)

    local estado =
        maquinaEstado.estadoActual


    ----------------------------------------
    -- ENVIAR TECLA AL ESTADO ACTUAL
    ----------------------------------------

    if estado.teclaPresionada ~= nil then

        estado:teclaPresionada(
            tecla
        )

    end

end


------------------------------------------------
-- CLICK DEL MOUSE
------------------------------------------------

function love.mousepressed(
    x,
    y,
    boton
)

    if boton == 1 then

        local estado =
            maquinaEstado.estadoActual


        if estado.atacar ~= nil then

            estado:atacar()

        end

    end

end


------------------------------------------------
-- DIBUJAR
------------------------------------------------

function love.draw()

    maquinaEstado:dibujar()

end