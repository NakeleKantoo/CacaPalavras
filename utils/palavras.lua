local todas = {
    "livro",
    "caneta",
    "garfo",
    "panela",
    "mesa",
    "cama",
    "bolsa",
    "menina",
    "garoto",
    "pai",
    "mae",
    "arvore",
    "fogo",
    "homem",
    "mulher",
    "medica",
    "ator",
    "gato",
    "cavalo",
    "tigre",
    "mico",
    "capim",
    "goiaba",
    "banana",
    "limao",
    "mamao",
    "ilha",
    "lago",
    "rio",
    "mangue",
    "serra",
    "bairro",
    "cidade",
    "pais",
    "manha",
    "noite",
    "dia",
    "sol",
    "chuva",
    "vento",
    "mes",
    "seculo",
    "fada",
    "bruxa",
    "sereia",
    "flor",
    "roupa",
    "agua",
    "canela",
    "recado",
    "vida",
    "espera",
    "forca",
    "povo",
    "colega",
    "aguia",
    "boto",
    "manga",
    "ovo",
    "fome",
    "calor",
    "frio",
    "cartao",
    "radio",
    "pente",
    "janela",
    "tijolo",
    "telha",
    "jacare",
    "jaca",
    "maca",
    "caqui",
    "capim",
    "ipe",
    "cacto",
    "chuva",
    "terra",
    "lama",
    "placa",
    "leite",
    "cha",
    "cafe",
    "neve",
    "noite",
    "homem",
    "mulher",
    "praia",
    "jardim",
    "feira",
    "cinema",
    "bruxa",
    "duende",
    "serra",
    "kiwi",
    "xicara",
    "verde",
    "obvio",
    "marca",
    "mao",
    "saturno",
    "sufixo",
    "venus",
    "marte",
    "dois",
    "tres",
    "quatro",
    "cinco",
    "seis",
    "sete",
    "oito",
    "nove",
    "dez",
    "som",
    "fez",
    "uva",
    "ameixa",
    "amor",
    "mumia",
    "egito",
    "paixao",
    "dedo",
    "oceano",
    "lava",
    "boi",
    "vaca",
    "galinha",
    "cobra",
    "raposa",
    "cachorro",
    "jabuti",
    "tatu",
    "bola",
    "mochila",
    "escola",
    "certeza",
    "cheiro",
    "visao",
    "corda",
    "sempre",
    "amigo",
    "visita",
    "errado",
    "justica",
    "prisao",
    "capivara",
    "furao",
    "girafa",
    "leao",
    "leopardo",
    "guepardo",
    "teia",
    "tecido",
    "cipo",
    "papel",
    "lapis",
    "tinta",
    "arte",
    "tarde",
    "metade",
    "porta",
    "laje",
    "lacre",
    "futuro",
    "passado",
    "presente",
    "bingo",
    "palavras",
    "magia",
    "ouro",
    "prata",
    "ferro",
    "riacho",
    "louco",
    "feixe",
    "carta",
    "maquina",
    "manual",
    "maionese",
    "mansao",
    "casa",
    "apertado",
    "apito",
    "musica",
    "fichario",
    "lista",
    "cansado",
    "brasil",
    "grito",
    "fiel",
    "cavalheiro",
    "carne",
    "carta",
    "correio",
    "loja",
    "pedra",
    "rocha",
    "vale",
    "beleza",
    "portugal",
    "jupiter",
    "urano",
    "netuno",
    "mercurio",
    "carbono",
    "oxigenio",
    "trabalho",
    "emprego",
    "seguro",
    "baixo",
    "alto",
    "grego",
    "caixa",
    "america",
    "europa",
    "asia",
    "africa",
    "oceania",
    "melancia",
    "portaria",
    "piloto",
    "presa",
    "veneno",
    "beijo"
}

function getRandomWords(num)
    local obj = {}
    while #obj<num do
        ::retry::
        local index = rng(1,#todas)
        local word = todas[index]
        local found = false
        if #word>=math.min(boardW,boardH) then goto retry end
        for k,v in ipairs(obj) do
            if v==word then
                found=true
            end
        end
        if found==false then
            table.insert(obj,word)
        end
    end
    return obj
end