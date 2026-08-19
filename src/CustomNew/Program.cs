using System;
using System.IO;
using System.Windows.Forms;

namespace CustomNew;

internal static class Program
{
    [STAThread]
    static void Main(string[] args)
    {
        ApplicationConfiguration.Initialize();

        string directory;

        if (args.Length > 0 && Directory.Exists(args[0]))
        {
            directory = args[0];
        }
        else
        {
            directory = Environment.GetFolderPath(
                Environment.SpecialFolder.Desktop);
        }

        using var form = new MainForm(directory);
        Application.Run(form);
    }
}

public class MainForm : Form
{
    private readonly TextBox filenameBox;
    private readonly Button createButton;
    private readonly Button cancelButton;

    private readonly string targetDirectory;

    public MainForm(string directory)
    {
        targetDirectory = directory;

        Text = "Create Custom File";
        Width = 500;
        Height = 180;
        StartPosition = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox = false;
        MinimizeBox = false;

        var filenameLabel = new Label
        {
            Text = "Filename:",
            Left = 20,
            Top = 20,
            Width = 100
        };

        filenameBox = new TextBox
        {
            Left = 20,
            Top = 45,
            Width = 440
        };

        createButton = new Button
        {
            Text = "Create",
            Left = 300,
            Top = 85,
            Width = 75
        };

        cancelButton = new Button
        {
            Text = "Cancel",
            Left = 385,
            Top = 85,
            Width = 75
        };

        createButton.Click += CreateFile;
        cancelButton.Click += (_, _) => Close();

        AcceptButton = createButton;
        CancelButton = cancelButton;

        Controls.Add(filenameLabel);
        Controls.Add(filenameBox);
        Controls.Add(createButton);
        Controls.Add(cancelButton);

        Shown += (_, _) =>
        {
            filenameBox.Focus();
        };
    }

    private void CreateFile(object? sender, EventArgs e)
    {
        string filename = filenameBox.Text.Trim();

        if (string.IsNullOrWhiteSpace(filename))
        {
            MessageBox.Show(
                "Please enter a filename.",
                "Custom File",
                MessageBoxButtons.OK,
                MessageBoxIcon.Warning);

            return;
        }

        if (filename.IndexOfAny(Path.GetInvalidFileNameChars()) >= 0)
        {
            MessageBox.Show(
                "The filename contains characters that Windows does not allow.",
                "Invalid Filename",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);

            return;
        }

        string fullPath = Path.Combine(targetDirectory, filename);

        if (File.Exists(fullPath) || Directory.Exists(fullPath))
        {
            MessageBox.Show(
                "A file or folder with that name already exists.",
                "File Already Exists",
                MessageBoxButtons.OK,
                MessageBoxIcon.Warning);

            return;
        }

        try
        {
            File.WriteAllText(fullPath, string.Empty);
            Close();
        }
        catch (Exception ex)
        {
            MessageBox.Show(
                $"Could not create the file.\n\n{ex.Message}",
                "Custom File",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
        }
    }
}