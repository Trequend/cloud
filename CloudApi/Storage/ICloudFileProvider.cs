namespace CloudApi.Storage;

public interface ICloudFileProvider
{
    public Task<string> SaveFileAsync(IFormFile file);

    public Stream GetFileStream(string id);

    public void DeleteFile(string id);
}
