Estado = {}


------------------------------------------------
-- CREAR ESTADO
------------------------------------------------

function Estado:nuevo()

    local estado = {}

    setmetatable(
        estado,
        {
            __index = Estado
        }
    )

    return estado

end


------------------------------------------------
-- ENTRAR AL ESTADO
------------------------------------------------

function Estado:entrar()

end


------------------------------------------------
-- SALIR DEL ESTADO
------------------------------------------------

function Estado:salir()

end


------------------------------------------------
-- ACTUALIZAR ESTADO
------------------------------------------------

function Estado:actualizar(dt)

end


------------------------------------------------
-- DIBUJAR ESTADO
------------------------------------------------

function Estado:dibujar()

end