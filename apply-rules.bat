@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

echo DEBUG: Script started

if "%~1"=="" (
    echo Error: Please provide the target project directory
    echo Usage: %~nx0 ^<target-project-directory^>
    exit /b 1
)
set "TARGET_DIR=%~1"

if not exist "%TARGET_DIR%\" (
    echo Creating new project directory: %TARGET_DIR%
    mkdir "%TARGET_DIR%"
    (
        echo # New Project
        echo.
        echo This project has been initialized with agile workflow support and auto rule generation configured from [cursor-auto-rules-agile-workflow](https://github.com/bmadcode/cursor-auto-rules-agile-workflow)
        echo.
        echo For workflow documentation, see [Workflow Rules](docs/workflow-rules.md)
    ) > "%TARGET_DIR%\README.md"
)

if not exist "%TARGET_DIR%\.cursor\rules\" (
    mkdir "%TARGET_DIR%\.cursor\rules"
)

if not exist "%TARGET_DIR%\.cursor\templates\" (
    mkdir "%TARGET_DIR%\.cursor\templates"
)

echo Copying core rule files...
xcopy ".cursor\rules\*.*" "%TARGET_DIR%\.cursor\rules\" /E /I /Y >nul

echo Copying template files...
xcopy ".cursor\templates\*.*" "%TARGET_DIR%\.cursor\templates\" /E /I /Y >nul

if not exist "%TARGET_DIR%\docs\" (
    mkdir "%TARGET_DIR%\docs"
)
(
    echo # Cursor Workflow Rules
    echo.
    echo This project has been updated to use the auto rule generator from [cursor-auto-rules-agile-workflow](https://github.com/bmadcode/cursor-auto-rules-agile-workflow)
    echo.
    echo ^> **Note**: This script can be safely re-run at any time to update the template rules to their latest versions^. It will not impact or overwrite any custom rules you've created^.
    echo.
    echo ## Core Features
    echo.
    echo - Automated rule generation
    echo - Standardized documentation formats
    echo - Supports all four Note Types automatically
    echo - AI behavior control and optimization
    echo - Flexible workflow integration options
    echo.
    echo ## Getting Started
    echo.
    echo 1^. Review the templates in `xnotes/`
    echo 2^. Choose your preferred workflow approach
    echo 3^. Start using the AI with confidence!
    echo.
    echo For demos and tutorials, visit: [BMad Code Videos](https://youtube^.com/bmadcode)
) > "%TARGET_DIR%\docs\workflow-rules.md"

REM Update .gitignore with xnotes and docs
if exist "%TARGET_DIR%\.gitignore" (
    findstr /L /C:".cursor/rules/_*.mdc" "%TARGET_DIR%\.gitignore" >nul
    if errorlevel 1 (
        (
            echo.
            echo # Private individual user cursor rules
            echo .cursor/rules/_*.mdc
            echo.
            echo # Documentation and templates
            echo xnotes/
            echo docs/
        ) >> "%TARGET_DIR%\.gitignore"
    )
) else (
    (
        echo # Private individual user cursor rules
        echo .cursor/rules/_*.mdc
        echo.
        echo # Documentation and templates
        echo xnotes/
        echo docs/
    ) > "%TARGET_DIR%\.gitignore"
)

REM Add sample xnotes
echo Setting up sample xnotes file...
if not exist "%TARGET_DIR%\xnotes\" (
    mkdir "%TARGET_DIR%\xnotes"
)
xcopy "xnotes\*.*" "%TARGET_DIR%\xnotes\" /E /I /Y >nul

REM Update .cursorignore
if exist "%TARGET_DIR%\.cursorignore" (
    findstr /L /C:"xnotes/" "%TARGET_DIR%\.cursorignore" >nul
    if errorlevel 1 (
        (
            echo.
            echo # Project notes and templates
            echo xnotes/
        ) >> "%TARGET_DIR%\.cursorignore"
    )
) else (
    (
        echo # Project notes and templates
        echo xnotes/
    ) > "%TARGET_DIR%\.cursorignore"
)

REM Create or update .cursorindexingignore
if exist "%TARGET_DIR%\.cursorindexingignore" (
    findstr /L /C:".cursor/templates/" "%TARGET_DIR%\.cursorindexingignore" >nul
    if errorlevel 1 (
        (
            echo.
            echo # Templates - accessible but not indexed
            echo .cursor/templates/
        ) >> "%TARGET_DIR%\.cursorindexingignore"
    )
) else (
    (
        echo # Templates - accessible but not indexed
        echo .cursor/templates/
    ) > "%TARGET_DIR%\.cursorindexingignore"
)

echo .
echo Deployment Complete!
echo Core rule generator: $TARGET_DIR/.cursor/rules/core-rules/rule-generating-agent.mdc
echo Sample sub-folders and rules: $TARGET_DIR/.cursor/rules/{sub-folders}/
echo Sample Agile Workflow Templates: $TARGET_DIR/.cursor/templates/
echo Workflow Documentation: $TARGET_DIR/docs/workflow-rules.md
echo Updated .gitignore, .cursorignore, and .cursorindexingignore

endlocal
