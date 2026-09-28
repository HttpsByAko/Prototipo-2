MaquinaEstado = {}


------------------------------------------------
-- CREAR MÁQUINA DE ESTADOS
------------------------------------------------

function MaquinaEstado:nuevo()

    local maquina = {}

    maquina.estadoActual = nil

    setmetatable(
        maquina,
        {
            __index = MaquinaEstado
        }
    )

    return maquina

end


------------------------------------------------
-- CAMBIAR DE ESTADO
------------------------------------------------

function MaquinaEstado:cambiar(nuevoEstado)

    ----------------------------------------
    -- SALIR DEL ESTADO ACTUAL
    ----------------------------------------

    if self.estadoActual ~= nil then

        self.estadoActual:salir()

    end


    ----------------------------------------
    -- CAMBIAR ESTADO
    ----------------------------------------

    self.estadoActual = nuevoEstado


    ----------------------------------------
    -- ENTRAR AL NUEVO ESTADO
    ----------------------------------------

    if self.estadoActual ~= nil then

        self.estadoActual:entrar()

    end

end


------------------------------------------------
-- ACTUALIZAR
------------------------------------------------

function MaquinaEstado:actualizar(dt)

    if self.estadoActual ~= nil then

        self.estadoActual:actualizar(dt)

    end

end


------------------------------------------------
-- DIBUJAR
------------------------------------------------

function MaquinaEstado:dibujar()

    if self.estadoActual ~= nil then

        self.estadoActual:dibujar()

    end

end