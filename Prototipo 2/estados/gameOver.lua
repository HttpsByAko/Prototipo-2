require("estados/estado")


EstadoGameOver = {}


------------------------------------------------
-- CREAR ESTADO
------------------------------------------------

function EstadoGameOver:nuevo(
    maquinaEstado,
    estadoJugando
)

    local estado = Estado:nuevo()


    estado.maquinaEstado =
        maquinaEstado

    estado.estadoJugando =
        estadoJugando


    setmetatable(
        estado,
        {
            __index = EstadoGameOver
        }
    )


    return estado

end


------------------------------------------------
-- ENTRAR AL ESTADO
------------------------------------------------

function EstadoGameOver:entrar()

end


------------------------------------------------
-- SALIR DEL ESTADO
------------------------------------------------

function EstadoGameOver:salir()

end


------------------------------------------------
-- ACTUALIZAR
------------------------------------------------

function EstadoGameOver:actualizar(dt)

end


------------------------------------------------
-- DIBUJAR
------------------------------------------------

function EstadoGameOver:dibujar()

    ----------------------------------------
    -- FONDO
    ----------------------------------------

    love.graphics.setColor(
        0.05,
        0.05,
        0.05
    )


    love.graphics.rectangle(
        "fill",
        0,
        0,
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )


    ----------------------------------------
    -- TEXTO GAME OVER
    ----------------------------------------

    love.graphics.setColor(
        1,
        1,
        1
    )


    local texto = "GAME OVER"


    local fuente =
        love.graphics.getFont()


    local ancho =
        fuente:getWidth(texto)


    local alto =
        fuente:getHeight(texto)


    love.graphics.print(
        texto,
        (love.graphics.getWidth() - ancho * 3) / 2,
        (love.graphics.getHeight() - alto * 3) / 2 - 30,
        0,
        3,
        3
    )


    ----------------------------------------
    -- TEXTO REINICIAR
    ----------------------------------------

    local textoReiniciar =
        "Presiona ENTER para reiniciar"


    local anchoReiniciar =
        fuente:getWidth(textoReiniciar)


    love.graphics.print(
        textoReiniciar,
        (love.graphics.getWidth() - anchoReiniciar * 1.5) / 2,
        love.graphics.getHeight() / 2 + 40,
        0,
        1.5,
        1.5
    )

end


------------------------------------------------
-- TECLA
------------------------------------------------

function EstadoGameOver:teclaPresionada(tecla)

    if tecla == "return" then

        ----------------------------------------
        -- REINICIAR DATOS DEL JUGADOR
        ----------------------------------------

        self.estadoJugando.jugador:nuevo()


        ----------------------------------------
        -- REINICIAR RONDAS
        ----------------------------------------

        self.estadoJugando.ronda = 0

        self.estadoJugando.numeroSala = 0


        ----------------------------------------
        -- ELIMINAR ENEMIGOS ANTERIORES
        ----------------------------------------

        self.estadoJugando.enemigos = {}


        ----------------------------------------
        -- CAMBIAR A JUGANDO
        ----------------------------------------

        self.maquinaEstado:cambiar(
            self.estadoJugando
        )

    end

end