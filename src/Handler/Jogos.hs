{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Jogos where
import Import
import Text.Lucius

getJogosR :: Handler Html
getJogosR = do
    jogos <- runDB $ selectList [] [Asc JogoNome]
    defaultLayout $ do
        sess <- lookupSession "_NOME"
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_style_css)
        toWidgetHead $(luciusFile "templates/jogos.lucius")
        $(whamletFile "templates/jogos.hamlet")