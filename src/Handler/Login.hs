{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing

getEntrarR :: Handler Html
getEntrarR = do 
    (widget,_) <- generateFormPost formLogin
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
                        Login de ussuário
                    <div>
                        $maybe mensa <- msg 
                            <div>
                                ^{mensa}
                        
                        <form method=post action=@{EntrarR}>
                            ^{widget}
                            <input type="submit" class="btn btn-default" value="Entrar">
        |]

postEntrarR :: Handler Html
postEntrarR = do 
    ((result,_),_) <- runFormPost formLogin
    case result of 
        FormSuccess ("root@root.com","root125") -> do 
            setSession "_NOME" "admin"
            redirect HomeR
        FormSuccess (email,senha) -> do 
           -- select * from usuario where email=digitado.email
           usuario <- runDB $ getBy (UniqueEmailIx email)
           case usuario of 
                Nothing -> do 
                    setMessage [shamlet|
                        <span class="label label-danger">
                            E-mail não encontrado.
                    |]
                    redirect EntrarR
                Just (Entity _ usu) -> do 
                    if (usuarioSenha usu == senha) then do
                        setSession "_NOME" (usuarioNome usu)
                        redirect HomeR
                    else do 
                        setMessage [shamlet|
                            <div>
                                Senha INCORRETA!
                        |]
                        redirect EntrarR 
        _ -> redirect HomeR

postSairR :: Handler Html 
postSairR = do 
    deleteSession "_NOME"
    redirect HomeR