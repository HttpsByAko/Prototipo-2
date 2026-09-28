Jugador = {}


------------------------------------------------
-- CREAR JUGADOR
------------------------------------------------

function Jugador:nuevo()

    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2

    self.tamaño = 32
    self.velocidad = 250

    self.vidaMaxima = 3
    self.vida = self.vidaMaxima


    ----------------------------------------
    -- INVULNERABILIDAD
    ----------------------------------------

    self.tiempoInvulnerable = 0
    self.duracionInvulnerabilidad = 0.7


    ----------------------------------------
    -- DATOS DEL ATAQUE
    ----------------------------------------

    self.alcanceAtaque = 55
    self.tamañoAtaque = 40

    self.dañoAtaque = 1

    self.cooldownAtaque = 0.3
    self.tiempoAtaque = 0

    self.duracionAtaque = 0.3
    self.tiempoAtaqueVisual = 0

    self.atacando = false

    self.direccionAtaqueX = 0
    self.direccionAtaqueY = 0

end


------------------------------------------------
-- RECIBIR DAÑO
------------------------------------------------

function Jugador:recibirDaño(daño)

    ----------------------------------------
    -- NO RECIBIR DAÑO SI ESTÁ INVULNERABLE
    ----------------------------------------

    if self.tiempoInvulnerable > 0 then
        return
    end


    ----------------------------------------
    -- QUITAR VIDA
    ----------------------------------------

    self.vida =
        self.vida - daño


    ----------------------------------------
    -- ACTIVAR INVULNERABILIDAD
    ----------------------------------------

    self.tiempoInvulnerable =
        self.duracionInvulnerabilidad


    ----------------------------------------
    -- EVITAR VIDA NEGATIVA
    ----------------------------------------

    if self.vida < 0 then

        self.vida = 0

    end

end


------------------------------------------------
-- ACTUALIZAR
------------------------------------------------

function Jugador:actualizar(dt, obstaculos)

    local movimientoX = 0
    local movimientoY = 0


    ----------------------------------------
    -- MOVIMIENTO
    ----------------------------------------

    if love.keyboard.isDown("w") then
        movimientoY = movimientoY - 1
    end

    if love.keyboard.isDown("s") then
        movimientoY = movimientoY + 1
    end

    if love.keyboard.isDown("a") then
        movimientoX = movimientoX - 1
    end

    if love.keyboard.isDown("d") then
        movimientoX = movimientoX + 1
    end


    ----------------------------------------
    -- MOVIMIENTO HORIZONTAL
    ----------------------------------------

    local nuevoX =
        self.x +
        movimientoX *
        self.velocidad *
        dt


    local mitad =
        self.tamaño / 2

    local grosor = 40


    if nuevoX - mitad >= grosor
    and nuevoX + mitad <=
        love.graphics.getWidth() - grosor then

        if not Generador:colisiona(
            nuevoX,
            self.y,
            self.tamaño,
            obstaculos
        ) then

            self.x = nuevoX

        end

    end


    ----------------------------------------
    -- MOVIMIENTO VERTICAL
    ----------------------------------------

    local nuevoY =
        self.y +
        movimientoY *
        self.velocidad *
        dt


    if nuevoY - mitad >= grosor
    and nuevoY + mitad <=
        love.graphics.getHeight() - grosor then

        if not Generador:colisiona(
            self.x,
            nuevoY,
            self.tamaño,
            obstaculos
        ) then

            self.y = nuevoY

        end

    end


    ----------------------------------------
    -- ACTUALIZAR INVULNERABILIDAD
    ----------------------------------------

    if self.tiempoInvulnerable > 0 then

        self.tiempoInvulnerable =
            self.tiempoInvulnerable - dt


        if self.tiempoInvulnerable < 0 then

            self.tiempoInvulnerable = 0

        end

    end


    ----------------------------------------
    -- COOLDOWN
    ----------------------------------------

    if self.tiempoAtaque > 0 then

        self.tiempoAtaque =
            self.tiempoAtaque - dt

    end


    ----------------------------------------
    -- DURACIÓN DEL ATAQUE
    ----------------------------------------

    if self.atacando then

        self.tiempoAtaqueVisual =
            self.tiempoAtaqueVisual - dt


        if self.tiempoAtaqueVisual <= 0 then

            self.tiempoAtaqueVisual = 0

            self.atacando = false

        end

    end

end


------------------------------------------------
-- ATAQUE
------------------------------------------------

function Jugador:atacar(enemigos)

    ----------------------------------------
    -- COOLDOWN
    ----------------------------------------

    if self.tiempoAtaque > 0 then
        return
    end


    ----------------------------------------
    -- POSICIÓN DEL MOUSE
    ----------------------------------------

    local mouseX =
        love.mouse.getX()

    local mouseY =
        love.mouse.getY()


    ----------------------------------------
    -- DIRECCIÓN DEL ATAQUE
    ----------------------------------------

    local direccionX =
        mouseX - self.x

    local direccionY =
        mouseY - self.y


    local distancia =
        math.sqrt(
            direccionX * direccionX +
            direccionY * direccionY
        )


    if distancia == 0 then
        return
    end


    direccionX =
        direccionX / distancia

    direccionY =
        direccionY / distancia


    self.direccionAtaqueX =
        direccionX

    self.direccionAtaqueY =
        direccionY


    ----------------------------------------
    -- ACTIVAR ATAQUE
    ----------------------------------------

    self.atacando = true

    self.tiempoAtaqueVisual =
        self.duracionAtaque


    self.tiempoAtaque =
        self.cooldownAtaque


    ----------------------------------------
    -- POSICIÓN DE LA HITBOX
    ----------------------------------------

    local hitboxX =
        self.x +
        direccionX *
        self.alcanceAtaque


    local hitboxY =
        self.y +
        direccionY *
        self.alcanceAtaque


    ----------------------------------------
    -- DAÑO
    ----------------------------------------

    for i, enemigo in ipairs(enemigos) do

        local distanciaX =
            enemigo.x - hitboxX

        local distanciaY =
            enemigo.y - hitboxY


        local distanciaEnemigo =
            math.sqrt(
                distanciaX * distanciaX +
                distanciaY * distanciaY
            )


        local distanciaMaxima =
            self.tamañoAtaque / 2 +
            enemigo.tamaño / 2


        if distanciaEnemigo <= distanciaMaxima then

            enemigo:recibirDaño(
                self.dañoAtaque
            )

        end

    end

end


------------------------------------------------
-- DIBUJAR
------------------------------------------------

function Jugador:dibujar()

    ----------------------------------------
    -- JUGADOR
    ----------------------------------------

    if self.tiempoInvulnerable > 0 then

        love.graphics.setColor(
            1,
            1,
            1
        )

    else

        love.graphics.setColor(
            0.2,
            0.5,
            1
        )

    end


    love.graphics.rectangle(
        "fill",
        self.x - self.tamaño / 2,
        self.y - self.tamaño / 2,
        self.tamaño,
        self.tamaño
    )


    ----------------------------------------
    -- HITBOX DEL ATAQUE
    ----------------------------------------

    if self.atacando then

        local hitboxX =
            self.x +
            self.direccionAtaqueX *
            self.alcanceAtaque


        local hitboxY =
            self.y +
            self.direccionAtaqueY *
            self.alcanceAtaque


        love.graphics.setColor(
            1,
            1,
            1
        )


        love.graphics.rectangle(
            "fill",
            hitboxX - self.tamañoAtaque / 2,
            hitboxY - self.tamañoAtaque / 2,
            self.tamañoAtaque,
            self.tamañoAtaque
        )

    end


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
        self.y - 38,
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
        self.y - 38,
        40 *
        (self.vida / self.vidaMaxima),
        5
    )

end