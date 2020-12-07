{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formUsu :: Form (Usuario, Text)
formUsu = renderBootstrap $ (,)
    <$> (Usuario 
        <$> areq textField "Nome: " Nothing
        <*> areq emailField "E-mail: " Nothing
        <*> areq passwordField "Senha: " Nothing)
    <*> areq passwordField "Digite Novamente: " Nothing

getUsuarioR :: Handler Html
getUsuarioR = do 
    (widget,_) <- generateFormPost formUsu
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_style_css)
        [whamlet|
            <div class="container">
                <nav class="navbar navbar-default">
                    <div class="container-fluid">
                        <div class="navbar-header">
                            <a class="navbar-brand" href=@{HomeR}>
                                <img src=@{StaticR joystic_png} class="img-menu">

                        <div id="navbar" class="navbar-collapse">
                            <ul class="nav navbar-nav">
                                <li>
                                    <a href=@{DesenvolvedorasR}>
                                        Lista de desenvolvedoras
                                
                                <li>
                                    <a href=@{DesenvolvedoraR}>
                                        Cadastrar desenvolvedoras
                                
                                <li>
                                    <a href=@{JogosR}>
                                        Lista de jogos
                                
                                <li>
                                    <a href=@{JogoR}>
                                        Cadastrar jogos

                <div class="jumbotron">
                    <h1>
                        Cadastro de usuário
                    
                    <div>
                        $maybe mensa <- msg 
                            <div>
                                ^{mensa}
                    
                    <form method=post action=@{UsuarioR}>
                        ^{widget}
                        <input type="submit" class="btn btn-default" value="Cadastrar">
        |]

postUsuarioR :: Handler Html
postUsuarioR = do 
    ((result,_),_) <- runFormPost formUsu
    case result of 
        FormSuccess (usuario,veri) -> do 
            if (usuarioSenha usuario == veri) then do 
                runDB $ insert usuario 
                setMessage [shamlet|
                    <span class="label label-success">
                        Usuário criado com sucesso
                |]
                redirect UsuarioR
            else do 
                setMessage [shamlet|
                    <span class="label label-warning">
                        Senha e verificação não conferem
                |]
                redirect UsuarioR
        _ -> redirect HomeR






