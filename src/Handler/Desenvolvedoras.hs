{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Desenvolvedoras where
import Import
import Text.Lucius

getDesenvolvedorasR :: Handler Html
getDesenvolvedorasR = do
    desenvolvedoras <- runDB $ selectList [] [Asc DesenvolvedoraNome]
    defaultLayout $ do
        sess <- lookupSession "_NOME"
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(luciusFile "templates/desenvolvedoras.lucius")
        $(whamletFile "templates/desenvolvedoras.hamlet")